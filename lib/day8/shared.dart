import 'dart:math';

import 'package:aoc_2024/lib.dart';

typedef Location = Point<int>;

final class FrequencyMap {
  // Map of frequencies to locations.
  final Map<String, List<Location>> antennaLocations;
  final int height;
  final int width;

  FrequencyMap(
      {required this.antennaLocations,
      required this.height,
      required this.width});

  bool inBounds(final Location location) {
    return location.x >= 0 &&
        location.x < height &&
        location.y >= 0 &&
        location.y < width;
  }
}

/// Loads data from file, which is a map of frequency to
/// locations (points on a map).
Future<FrequencyMap> loadData(Resources resources) async {
  final file = resources.file(Day.day8);
  final lines = await file.readAsLines();

  Map<String, List<Location>> frequencies = {};

  for (int r = 0; r < lines.length; r++) {
    final line = lines[r];
    for (int c = 0; c < line.length; c++) {
      if (line[c] == '.') {
        continue;
      }

      final frequency = frequencies.putIfAbsent(line[c], () => []);
      frequency.add(Location(r, c));
    }
  }

  return FrequencyMap(
      antennaLocations: frequencies,
      height: lines.length,
      width: lines[0].length);
}
