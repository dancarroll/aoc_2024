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
  final map = await loadData(resources);
  final person = map.person;
  
  while (person.inBounds(map.numRows, map.numCols)) {
    // Determine where the person would move next.
    var nextPosition = person.nextStep;
    var nextLocation = map[nextPosition];

    if (nextLocation != null && nextLocation.isObstruction) {
      // When encountering an obstruction, turn 90 degrees instead
      // of moving.
      person.direction = person.direction.rotate();
    } else {
      // Otherwise, move forward.
      person.move(nextPosition);

      // If this position maps to a map location, mark it as visited.
      nextLocation?.visited = true;
    }
  }

  return map.numVisited;
}
