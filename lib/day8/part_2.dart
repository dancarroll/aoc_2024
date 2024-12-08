import 'package:aoc_2024/lib.dart';

import 'shared.dart';

/// Continuing from part 1, include all harmonics of the frequency
/// when determining the number of antinode locations.
///
/// This mean including any grid position that is exactly in line with
/// at least two antennas of the same frequency, regardless of distance.
/// It also means that the antenna locations themselves can be considered
/// as antinode locations.
///
/// Return value is the same as part 1: number of unique locations that
/// are antinodes.
Future<int> calculate(Resources resources) async {
  final frequencyMap = await loadData(resources);
  return frequencyMap.antinodes(includeHarmonics: true).length;
}
