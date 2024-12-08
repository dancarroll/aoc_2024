import 'package:aoc_2024/lib.dart';

import 'shared.dart';

Future<int> calculate(Resources resources) async {
  final frequencyMap = await loadData(resources);
  return frequencyMap.antinodes(includeHarmonics: true).length;
}
