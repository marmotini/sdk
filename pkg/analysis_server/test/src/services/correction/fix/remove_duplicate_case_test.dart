// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analysis_server/src/services/correction/fix.dart';
import 'package:analysis_server/src/services/correction/fix_internal.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'fix_processor.dart';

main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(RemoveDuplicateCaseTest);
  });
}

@reflectiveTest
class RemoveDuplicateCaseTest extends FixProcessorLintTest {
  @override
  FixKind get kind => DartFixKind.REMOVE_DUPLICATE_CASE;

  @override
  String get lintCode => LintNames.no_duplicate_case_values;

  test_removeStringCase() async {
    await resolveTestUnit('''
void switchString() {
  String v = 'a';
  switch (v) {
    case 'a':
      print('a');
      break;
    case 'b':
      print('b');
      break;
    case 'a' /*LINT*/:
      print('a');
      break;
    default:
      print('?);
  }
}
''');
    await assertHasFix('''
void switchString() {
  String v = 'a';
  switch (v) {
    case 'a':
      print('a');
      break;
    case 'b':
      print('b');
      break;
    default:
      print('?);
  }
}
''');
  }

  test_removeIntCase() async {
    await resolveTestUnit('''
void switchInt() {
  switch (2) {
    case 1:
      print('a');
      break;
    case 2:
    case 2 /*LINT*/:
    default:
      print('?);
  }
}
''');
    await assertHasFix('''
void switchInt() {
  switch (2) {
    case 1:
      print('a');
      break;
    case 2:
    default:
      print('?);
  }
}
''');
  }
}
