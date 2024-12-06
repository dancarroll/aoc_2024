import 'dart:math';

import 'package:aoc_2024/lib.dart';

/// Represents a location within the map.
class Location {
  /// True if this location was previously visited by the person.
  bool visited;

  /// True if this location is an obstruction, and the person is
  /// unable to move to this location.
  bool isObstruction;

  Location({this.isObstruction = false, this.visited = false});
}

/// Represents a direction of travel within the map.
enum Direction {
  up,
  right,
  down,
  left;

  /// Calculates the new point based on a given point and this
  /// direction of travel.
  Point<int> move(Point<int> point) => switch (this) {
        up => Point(point.x - 1, point.y),
        down => Point(point.x + 1, point.y),
        left => Point(point.x, point.y - 1),
        right => Point(point.x, point.y + 1)
      };

  /// Returns a new direction based on a 90 degree rotation.
  Direction rotate() {
    var nextIndex = index + 1;
    if (nextIndex >= Direction.values.length) {
      nextIndex = 0;
    }
    return Direction.values[nextIndex];
  }
}

class Person {
  Point<int> point;
  Direction direction;

  Person(int x, int y, this.direction) : point = Point(x, y);

  bool inBounds(int numRows, int numCols) =>
      _inBounds(numRows: numRows, numCols: numCols, x: point.x, y: point.y);

  Point<int> get nextStep => direction.move(point);

  void move(Point<int> position) => point = position;
}

bool _inBounds(
        {required int numRows,
        required int numCols,
        required int x,
        required int y}) =>
    x >= 0 && x < numRows && y >= 0 && y < numCols;

final class LocationMap {
  final List<List<Location>> map;
  final Person person;

  LocationMap(this.map, this.person);

  factory LocationMap.fromStrings(List<String> input) {
    late Person person;
    final List<List<Location>> locationMap = [];

    for (int r = 0; r < input.length; r++) {
      final line = input[r].split('');
      final List<Location> locations = [];

      for (int c = 0; c < line.length; c++) {
        late Location location;
        switch (line[c]) {
          case '.':
            location = Location();
          case '#':
            location = Location(isObstruction: true);
          // The sample input, and my real input, both contain
          // `^` as the starting guard position. The puzzle itself
          // does not indicate that the starting direction could
          // be arbitrary, so currently just handling this starting
          // direction.
          case '^':
            location = Location(visited: true);
            person = Person(r, c, Direction.up);
          default:
            throw Exception('Unexpected character: ${line[c]}');
        }

        locations.add(location);
      }

      locationMap.add(locations);
    }

    return LocationMap(locationMap, person);
  }

  int get numRows => map.length;
  int get numCols => map[0].length;

  Location? operator [](Point<int> p) {
    if (_inBounds(numRows: numRows, numCols: numCols, x: p.x, y: p.y)) {
      return map[p.x][p.y];
    }
    return null;
  }

  int get numVisited => map
      .map((locations) => locations.fold(0, (v, e) => v + (e.visited ? 1 : 0)))
      .reduce((v, e) => v + e);
}

Future<LocationMap> loadData(Resources resources) async {
  final file = resources.file(Day.day6);
  final lines = await file.readAsLines();

  return LocationMap.fromStrings(lines);
}
