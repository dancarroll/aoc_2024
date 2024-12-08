import 'package:aoc_2024/lib.dart';

import 'shared.dart';

//typedef LocationPair = ({AntennaLocation a, AntennaLocation b});

Future<int> calculate(Resources resources) async {
  final frequencyMap = await loadData(resources);

  // Store a map of antinodes. Since antinodes could be at the
  // same location as another antinode, each location has a
  // list of frequencies.
  Map<Location, Set<String>> antinodes = {};

  for (final frequency in frequencyMap.antennaLocations.entries) {
    for (final pair in pairwise(frequency.value)) {
      final antinodeLocations = anitnodeLocations(pair.$1, pair.$2)
          .where((l) => frequencyMap.inBounds(l));

      for (final location in antinodeLocations) {
        antinodes.putIfAbsent(location, () => {}).add(frequency.key);
      }
    }
  }

  return antinodes.keys.length;
}

List<(T, T)> pairwise<T>(List<T> items) {
  List<(T, T)> records = [];
  for (int i = 0; i < items.length - 1; i++) {
    for (int j = i + 1; j < items.length; j++) {
      records.add((items[i], items[j]));
    }
  }
  return records;
}

Iterable<Location> anitnodeLocations(Location a, Location b) {
  final diff = a - b;
  final locations = [a + diff, a - diff, b + diff, b - diff];

  return locations.where((e) => e != a && e != b);
}
