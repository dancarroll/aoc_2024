import 'package:aoc_2024/lib.dart';

import 'shared.dart';

Future<int> calculate(Resources resources) async {
  final contents = await loadData(resources);
  assert(contents.listA.length == contents.listB.length);

  var diff = 0;
  for (var i = 0; i < contents.listA.length; i++) {
    diff += (contents.listA[i] - contents.listB[i]).abs();
  }
  return diff;
}
