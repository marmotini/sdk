// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Verify creating a script snapshot twice generates the same bits.

import 'dart:async';
import 'snapshot_test_helper.dart';

int fib(int n) {
  if (n <= 1) return 1;
  return fib(n - 1) + fib(n - 2);
}

Future<void> main(List<String> args) async {
  if (args.contains('--child')) {
    print(fib(35));
    return;
  }

  await checkDeterministicSnapshot("script", "");
}
