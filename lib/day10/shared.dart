import 'dart:io';
import 'dart:math' as math;

import 'package:collection/collection.dart';

/// Represents a single point on a topographic map.
final class Point {
  final math.Point<int> _point;
  final int val;

  Point({required int x, required int y, required this.val})
      : _point = math.Point(x, y);

  int get x => _point.x;
  int get y => _point.y;

  /// Returns true if this point is a trailhead.
  bool get isTrailhead => val == 0;

  /// Returns true if this point is a summit.
  bool get isSummit => val == 9;

  /// Returns true if the given point is reachable from this point
  /// (elevation is )
  bool isGradualStepFromPoint(Point other) => val == other.val + 1;

  @override
  String toString() {
    return _point.toString();
  }
}

/// Represents a topographic map where every point has a declared
/// integer elevation.
final class TopographicMap {
  final List<List<Point>> map;

  TopographicMap(this.map);

  factory TopographicMap.fromStringList(List<String> input) {
    List<List<Point>> map = [];

    for (int r = 0; r < input.length; r++) {
      List<Point> row = [];
      final line = input[r];
      for (int c = 0; c < line.length; c++) {
        row.add(Point(x: r, y: c, val: int.parse(line[c])));
      }

      map.add(row);
    }

    return TopographicMap(map);
  }

  int get height => map.length;
  int get width => map[0].length;

  /// Returns the point at the given coordinates.
  Point getPoint(int r, int c) {
    return map[r][c];
  }

  /// Returns all of the trailheads in this map.
  Iterable<Point> get trailheads => map.flattened.where((p) => p.isTrailhead);
}

/// Loads a topographic map from a file.
Future<TopographicMap> loadMap(File file) async {
  final lines = await file.readAsLines();

  return TopographicMap.fromStringList(lines);
}