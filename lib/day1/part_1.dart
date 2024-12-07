import 'package:aoc_2024/lib.dart';

import 'shared.dart';

/// Calculate the difference between two lists, by sorting
/// each list and adding up the difference of each pair.
Future<int> calculate(Resources resources) async {
  final contents = await loadData(resources);
  assert(contents.listA.length == contents.listB.length);

  var diff = 0;
  for (var i = 0; i < contents.listA.length; i++) {
    diff += (contents.listA[i] - contents.listB[i]).abs();
  }
  return diff;
}
