import 'dart:io';

import 'shared.dart';

/// Continuing from part 1 -- instead of 2 robots with directional keypads,
/// there are actually 25!
///
/// You -> Robot 1 -> ... -> Robot 25 -> Robot 26 (numeric keypad).
///
/// Return value is the same as before (sum of complexities).
Future<int> calculate(File file) async {
  final data = await loadData(file);

  int complexity = 0;
  for (final code in data) {
    final sequence = shortestSequence(code, 1, useNewSequenceGenerator: true);
    final sequenceComplexity = sequence * int.parse(code.substring(0, 3));
    complexity += sequenceComplexity;
  }

  return complexity;
}
