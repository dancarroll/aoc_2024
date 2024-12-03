import 'package:aoc_2024/lib.dart';

import 'shared.dart';

Future<int> calculate(Resources resources) async {
  final data = await loadData(resources);
  final val = data.whereType<Mult>().fold(0, (v, e) => v + e.product);
  return val;
}
