import 'package:aoc_2024/lib.dart';

import 'shared.dart';

Future<int> calculate(Resources resources) async {
  final contents = await loadData(resources);

  var result = 0;
  for (final num in contents.listA) {
    final count = contents.listB.where((i) => i == num).length;
    result += num * count;
  }
  return result;
}