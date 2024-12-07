import 'package:aoc_2024/lib.dart';

import 'shared.dart';

/// Given a map with a starting location and obstructions,
/// determine how many unique locations a person visits
/// given a set of movement rules:
/// - Direction is indicated based on charact (^, >, <, v)
/// - Move forward until reaching an obstruction (#)
/// - When reaching obstruction, turn 90 degress right
/// - Continue until leaving the bounds of the map
Future<int> calculate(Resources resources) async {
  final map = await loadMap(resources);
  map.moveUntilPersonLeavesMap();
  return map.numVisited;
}
