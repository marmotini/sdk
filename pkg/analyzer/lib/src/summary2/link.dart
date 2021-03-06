// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart' show CompilationUnit;
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/src/dart/element/element.dart';
import 'package:analyzer/src/dart/element/inheritance_manager2.dart';
import 'package:analyzer/src/generated/engine.dart';
import 'package:analyzer/src/generated/resolver.dart';
import 'package:analyzer/src/generated/source.dart';
import 'package:analyzer/src/generated/type_system.dart';
import 'package:analyzer/src/summary/format.dart';
import 'package:analyzer/src/summary/idl.dart';
import 'package:analyzer/src/summary/summary_sdk.dart';
import 'package:analyzer/src/summary2/builder/source_library_builder.dart';
import 'package:analyzer/src/summary2/linked_bundle_context.dart';
import 'package:analyzer/src/summary2/linked_element_factory.dart';
import 'package:analyzer/src/summary2/linking_bundle_context.dart';
import 'package:analyzer/src/summary2/reference.dart';
import 'package:analyzer/src/summary2/reference_resolver.dart';
import 'package:analyzer/src/summary2/type_builder.dart';

LinkResult link(
  AnalysisOptions analysisOptions,
  SourceFactory sourceFactory,
  List<LinkedNodeBundle> inputs,
  Map<Source, Map<Source, CompilationUnit>> unitMap,
) {
  var linker = Linker(analysisOptions, sourceFactory);
  linker.link(inputs, unitMap);
  return LinkResult(linker.linkingBundle);
}

class Linker {
  final Reference rootReference = Reference.root();
  LinkedElementFactory elementFactory;

  LinkingBundleContext linkingBundleContext;
  List<LinkedNodeLibraryBuilder> linkingLibraries = [];
  LinkedNodeBundleBuilder linkingBundle;
  LinkedBundleContext bundleContext;

  /// Libraries that are being linked.
  final Map<Uri, SourceLibraryBuilder> builders = {};

  _AnalysisContextForLinking analysisContext;
  TypeProvider typeProvider;
  Dart2TypeSystem typeSystem;
  InheritanceManager2 inheritance;

  Linker(AnalysisOptions analysisOptions, SourceFactory sourceFactory) {
    var dynamicRef = rootReference.getChild('dart:core').getChild('dynamic');
    dynamicRef.element = DynamicElementImpl.instance;

    linkingBundleContext = LinkingBundleContext(dynamicRef);

    analysisContext = _AnalysisContextForLinking(
      analysisOptions,
      sourceFactory,
    );

    elementFactory = LinkedElementFactory(
      analysisContext,
      _AnalysisSessionForLinking(),
      rootReference,
    );

    linkingBundle = LinkedNodeBundleBuilder(
      references: linkingBundleContext.referencesBuilder,
      libraries: linkingLibraries,
    );

    bundleContext = LinkedBundleContext(
      elementFactory,
      linkingBundle.references,
    );
    bundleContext.linking = linkingBundleContext;
  }

  void link(List<LinkedNodeBundle> inputs,
      Map<Source, Map<Source, CompilationUnit>> unitMap) {
    for (var input in inputs) {
      elementFactory.addBundle(input);
    }

    for (var librarySource in unitMap.keys) {
      SourceLibraryBuilder.build(this, librarySource, unitMap[librarySource]);
    }

    // Add libraries being linked, so we can ask for their elements as well.
    elementFactory.addBundle(linkingBundle, context: bundleContext);

    _buildOutlines();
  }

  void _addExporters() {
    for (var library in builders.values) {
      library.addExporters();
    }
  }

  void _addSyntheticConstructors() {
    for (var library in builders.values) {
      library.addSyntheticConstructors();
    }
  }

  void _buildOutlines() {
    _addExporters();
    _computeLibraryScopes();
    _addSyntheticConstructors();
    _createTypeSystem();
    _resolveTypes();
    _performTopLevelInference();
    _resolveMetadata();
  }

  void _computeLibraryScopes() {
    var exporters = new Set<SourceLibraryBuilder>();
    var exportees = new Set<SourceLibraryBuilder>();

    for (var library in builders.values) {
      library.addLocalDeclarations();
      if (library.exporters.isNotEmpty) {
        exportees.add(library);
        for (var exporter in library.exporters) {
          exporters.add(exporter.exporter);
        }
      }
    }

    for (var library in builders.values) {
      library.buildInitialExportScope();
    }

    var both = new Set<SourceLibraryBuilder>();
    for (var exported in exportees) {
      if (exporters.contains(exported)) {
        both.add(exported);
      }
      for (var export in exported.exporters) {
        exported.exportScope.forEach(export.addToExportScope);
      }
    }

    while (true) {
      var hasChanges = false;
      for (var exported in both) {
        for (var export in exported.exporters) {
          exported.exportScope.forEach((name, member) {
            if (export.addToExportScope(name, member)) {
              hasChanges = true;
            }
          });
        }
      }
      if (!hasChanges) break;
    }

    for (var library in builders.values) {
      library.addImportsToScope();
    }

    for (var library in builders.values) {
      library.storeExportScope();
    }
  }

  void _createTypeSystem() {
    var coreRef = rootReference.getChild('dart:core');
    var coreLib = elementFactory.elementOfReference(coreRef);

    var asyncRef = rootReference.getChild('dart:async');
    var asyncLib = elementFactory.elementOfReference(asyncRef);

    typeProvider = SummaryTypeProvider()
      ..initializeCore(coreLib)
      ..initializeAsync(asyncLib);
    analysisContext.typeProvider = typeProvider;

    typeSystem = Dart2TypeSystem(typeProvider);
    analysisContext.typeSystem = typeSystem;

    inheritance = InheritanceManager2(typeSystem);
  }

  void _performTopLevelInference() {
    for (var library in builders.values) {
      library.performTopLevelInference();
    }
  }

  void _resolveMetadata() {
    for (var library in builders.values) {
      library.resolveMetadata();
    }
  }

  void _resolveTypes() {
    var typesToBuild = TypesToBuild();
    for (var library in builders.values) {
      library.resolveTypes(typesToBuild);
    }
    TypeBuilder(bundleContext).build(typesToBuild);
  }
}

class LinkResult {
  final LinkedNodeBundleBuilder bundle;

  LinkResult(this.bundle);
}

class _AnalysisContextForLinking implements InternalAnalysisContext {
  @override
  final AnalysisOptions analysisOptions;

  @override
  final SourceFactory sourceFactory;

  @override
  TypeProvider typeProvider;

  @override
  TypeSystem typeSystem;

  _AnalysisContextForLinking(this.analysisOptions, this.sourceFactory);

  @override
  Namespace getPublicNamespace(LibraryElement library) {
    // TODO(scheglov) Not sure if this method of AnalysisContext is useful.
    var builder = new NamespaceBuilder();
    return builder.createPublicNamespaceForLibrary(library);
  }

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _AnalysisSessionForLinking implements AnalysisSession {
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
