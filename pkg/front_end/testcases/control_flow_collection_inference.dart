// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Oracle is generic to test the inference in conditions of if-elements.
oracle<T>([T t]) => true;

testIfElement(dynamic dynVar, List<int> listInt, List<double> listDouble) {
  var list10 = [if (oracle("foo")) 42];
  var set10 = {if (oracle("foo")) 42, null};
  var list11 = [if (oracle("foo")) dynVar];
  var set11 = {if (oracle("foo")) dynVar, null};
  var list12 = [if (oracle("foo")) [42]];
  var set12 = {if (oracle("foo")) [42], null};
  var list20 = [if (oracle("foo")) ...[42]];
  var set20 = {if (oracle("foo")) ...[42], null};
  var list21 = [if (oracle("foo")) ...[dynVar]];
  var set21 = {if (oracle("foo")) ...[dynVar], null};
  var list22 = [if (oracle("foo")) ...[[42]]];
  var set22 = {if (oracle("foo")) ...[[42]], null};
  var list30 = [if (oracle("foo")) if (oracle()) ...[42]];
  var set30 = {if (oracle("foo")) if (oracle()) ...[42], null};
  var list31 = [if (oracle("foo")) if (oracle()) ...[dynVar]];
  var set31 = {if (oracle("foo")) if (oracle()) ...[dynVar], null};
  var list33 = [if (oracle("foo")) if (oracle()) ...[[42]]];
  var set33 = {if (oracle("foo")) if (oracle()) ...[[42]], null};
  List<List<int>> list40 = [if (oracle("foo")) ...[[]]];
  Set<List<int>> set40 = {if (oracle("foo")) ...[[]], null};
  List<List<int>> list41 = [if (oracle("foo")) ...{[]}];
  Set<List<int>> set41 = {if (oracle("foo")) ...{[]}, null};
  List<List<int>> list42 = [if (oracle("foo")) if (oracle()) ...[[]]];
  Set<List<int>> set42 = {if (oracle("foo")) if (oracle()) ...[[]], null};
  List<int> list50 = [if (oracle("foo")) ...[]];
  Set<int> set50 = {if (oracle("foo")) ...[], null};
  List<int> list51 = [if (oracle("foo")) ...{}];
  Set<int> set51 = {if (oracle("foo")) ...{}, null};
  List<int> list52 = [if (oracle("foo")) if (oracle()) ...[]];
  Set<int> set52 = {if (oracle("foo")) if (oracle()) ...[], null};
  List<List<int>> list60 = [if (oracle("foo")) ...[[]]];
  Set<List<int>> set60 = {if (oracle("foo")) ...[[]], null};
  List<List<int>> list61 = [if (oracle("foo")) if (oracle()) ...[[]]];
  Set<List<int>> set61 = {if (oracle("foo")) if (oracle()) ...[[]], null};
  List<List<int>> list70 = [if (oracle("foo")) []];
  Set<List<int>> set70 = {if (oracle("foo")) [], null};
  List<List<int>> list71 = [if (oracle("foo")) if (oracle()) []];
  Set<List<int>> set71 = {if (oracle("foo")) if (oracle()) [], null};
  var list80 = [if (oracle("foo")) 42 else 3.14];
  var set80 = {if (oracle("foo")) 42 else 3.14, null};
  var list81 = [if (oracle("foo")) ...listInt else ...listDouble];
  var set81 = {if (oracle("foo")) ...listInt else ...listDouble, null};
  var list82 = [if (oracle("foo")) ...listInt else ...dynVar];
  var set82 = {if (oracle("foo")) ...listInt else ...dynVar, null};
  var list83 = [if (oracle("foo")) 42 else ...listDouble];
  var set83 = {if (oracle("foo")) ...listInt else 3.14, null};
  List<int> list90 = [if (oracle("foo")) dynVar];
  Set<int> set90 = {if (oracle("foo")) dynVar, null};
  List<int> list91 = [if (oracle("foo")) ...dynVar];
  Set<int> set91 = {if (oracle("foo")) ...dynVar, null};
}

testIfElementErrors(Map<int, int> map) {
  <int>[if (oracle("foo")) "bar"];
  <int>{if (oracle("foo")) "bar", null};
  <int>[if (oracle("foo")) ...["bar"]];
  <int>{if (oracle("foo")) ...["bar"], null};
  <int>[if (oracle("foo")) ...map];
  <int>{if (oracle("foo")) ...map, null};
  <String>[if (oracle("foo")) 42 else 3.14];
  <String>{if (oracle("foo")) 42 else 3.14, null};
  <int>[if (oracle("foo")) ...map else 42];
  <int>{if (oracle("foo")) ...map else 42, null};
  <int>[if (oracle("foo")) 42 else ...map];
  <int>{if (oracle("foo")) ...map else 42, null};
}

testForElement(dynamic dynVar, List<int> listInt, List<double> listDouble, int
    index) {
  var list10 = [for (int i = 0; oracle("foo"); i++) 42];
  var set10 = {for (int i = 0; oracle("foo"); i++) 42, null};
  var list11 = [for (int i = 0; oracle("foo"); i++) dynVar];
  var set11 = {for (int i = 0; oracle("foo"); i++) dynVar, null};
  var list12 = [for (int i = 0; oracle("foo"); i++) [42]];
  var set12 = {for (int i = 0; oracle("foo"); i++) [42], null};
  var list20 = [for (int i = 0; oracle("foo"); i++) ...[42]];
  var set20 = {for (int i = 0; oracle("foo"); i++) ...[42], null};
  var list21 = [for (int i = 0; oracle("foo"); i++) ...[dynVar]];
  var set21 = {for (int i = 0; oracle("foo"); i++) ...[dynVar], null};
  var list22 = [for (int i = 0; oracle("foo"); i++) ...[[42]]];
  var set22 = {for (int i = 0; oracle("foo"); i++) ...[[42]], null};
  var list30 = [for (int i = 0; oracle("foo"); i++) if (oracle()) ...[42]];
  var set30 = {for (int i = 0; oracle("foo"); i++) if (oracle()) ...[42], null};
  var list31 = [for (int i = 0; oracle("foo"); i++) if (oracle()) ...[dynVar]];
  var set31 = {for (int i = 0; oracle("foo"); i++) if (oracle()) ...[dynVar], null};
  var list33 = [for (int i = 0; oracle("foo"); i++) if (oracle()) ...[[42]]];
  var set33 = {for (int i = 0; oracle("foo"); i++) if (oracle()) ...[[42]], null};
  List<List<int>> list40 = [for (int i = 0; oracle("foo"); i++) ...[[]]];
  Set<List<int>> set40 = {for (int i = 0; oracle("foo"); i++) ...[[]], null};
  List<List<int>> list41 = [for (int i = 0; oracle("foo"); i++) ...{[]}];
  Set<List<int>> set41 = {for (int i = 0; oracle("foo"); i++) ...{[]}, null};
  List<List<int>> list42 = [for (int i = 0; oracle("foo"); i++) if (oracle()) ...[[]]];
  Set<List<int>> set42 = {for (int i = 0; oracle("foo"); i++) if (oracle()) ...[[]], null};
  List<int> list50 = [for (int i = 0; oracle("foo"); i++) ...[]];
  Set<int> set50 = {for (int i = 0; oracle("foo"); i++) ...[], null};
  List<int> list51 = [for (int i = 0; oracle("foo"); i++) ...{}];
  Set<int> set51 = {for (int i = 0; oracle("foo"); i++) ...{}, null};
  List<int> list52 = [for (int i = 0; oracle("foo"); i++) if (oracle()) ...[]];
  Set<int> set52 = {for (int i = 0; oracle("foo"); i++) if (oracle()) ...[], null};
  List<List<int>> list60 = [for (int i = 0; oracle("foo"); i++) ...[[]]];
  Set<List<int>> set60 = {for (int i = 0; oracle("foo"); i++) ...[[]], null};
  List<List<int>> list61 = [for (int i = 0; oracle("foo"); i++) if (oracle()) ...[[]]];
  Set<List<int>> set61 = {for (int i = 0; oracle("foo"); i++) if (oracle()) ...[[]], null};
  List<List<int>> list70 = [for (int i = 0; oracle("foo"); i++) []];
  Set<List<int>> set70 = {for (int i = 0; oracle("foo"); i++) [], null};
  List<List<int>> list71 = [for (int i = 0; oracle("foo"); i++) if (oracle()) []];
  Set<List<int>> set71 = {for (int i = 0; oracle("foo"); i++) if (oracle()) [], null};
  var list80 = [for (int i = 0; oracle("foo"); i++) if (oracle()) 42 else 3.14];
  var set80 = {for (int i = 0; oracle("foo"); i++) if (oracle()) 42 else 3.14, null};
  var list81 = [for (int i = 0; oracle("foo"); i++) if (oracle()) ...listInt else ...listDouble];
  var set81 = {for (int i = 0; oracle("foo"); i++) if (oracle()) ...listInt else ...listDouble, null};
  var list82 = [for (int i = 0; oracle("foo"); i++) if (oracle()) ...listInt else ...dynVar];
  var set82 = {for (int i = 0; oracle("foo"); i++) if (oracle()) ...listInt else ...dynVar, null};
  var list83 = [for (int i = 0; oracle("foo"); i++) if (oracle()) 42 else ...listDouble];
  var set83 = {for (int i = 0; oracle("foo"); i++) if (oracle()) ...listInt else 3.14, null};
  List<int> list90 = [for (int i = 0; oracle("foo"); i++) dynVar];
  Set<int> set90 = {for (int i = 0; oracle("foo"); i++) dynVar, null};
  List<int> list91 = [for (int i = 0; oracle("foo"); i++) ...dynVar];
  Set<int> set91 = {for (int i = 0; oracle("foo"); i++) ...dynVar, null};
  List<int> list100 = <int>[for (index = 0; oracle("foo"); index++) 42];
  Set<int> set100 = <int>{for (index = 0; oracle("foo"); index++) 42};
  var list110 = [for (var i in [1, 2, 3]) i];
  var set110 = {for (var i in [1, 2, 3]) i, null};
  List<int> list120 = [for (var i in dynVar) i];
  Set<int> set120 = {for (var i in dynVar) i, null};
}

testForElementErrors(Map<int, int> map) async {
  <int>[for (int i = 0; oracle("foo"); i++) "bar"];
  <int>{for (int i = 0; oracle("foo"); i++) "bar", null};
  <int>[for (int i = 0; oracle("foo"); i++) ...["bar"]];
  <int>{for (int i = 0; oracle("foo"); i++) ...["bar"], null};
  <int>[for (int i = 0; oracle("foo"); i++) ...map];
  <int>{for (int i = 0; oracle("foo"); i++) ...map, null};
  <String>[for (int i = 0; oracle("foo"); i++) if (oracle()) 42 else 3.14];
  <String>{for (int i = 0; oracle("foo"); i++) if (oracle()) 42 else 3.14, null};
  <int>[for (int i = 0; oracle("foo"); i++) if (oracle()) ...map else 42];
  <int>{for (int i = 0; oracle("foo"); i++) if (oracle()) ...map else 42, null};
  <int>[for (int i = 0; oracle("foo"); i++) if (oracle()) 42 else ...map];
  <int>{for (int i = 0; oracle("foo"); i++) if (oracle()) ...map else 42, null};

  final i = 0;
  <int>[for (i in <int>[1]) i];
  <int>{for (i in <int>[1]) i, null};

  var list10 = [for (var i in "not iterable") i];
  var set10 = {for (var i in "not iterable") i, null};
  var list20 = [for (int i in ["not", "int"]) i];
  var set20 = {for (int i in ["not", "int"]) i, null};
  var list30 = [await for (var i in "not stream") i];
  var set30 = {await for (var i in "not stream") i, null};
  var list40 = [await for (int i in Stream.fromIterable(["not", "int"])) i];
  var set40 = {await for (int i in Stream.fromIterable(["not", "int"])) i, null};
  var list50 = [await for (;;) 42];
  var set50 = {await for (;;) 42, null};
  var list60 = [for (; "not bool";) 42];
  var set60 = {for (; "not bool";) 42, null};
}

testForElementErrorsNotAsync(Stream<int> stream) {
  <int>[await for (int i in stream) i];
  <int>{await for (int i in stream) i};
}

main() {}
