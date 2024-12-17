import 'dart:io';
import 'dart:math';

enum Location {
  wall,
  empty,
  start,
  end;
}

final class Maze {
  final Map<Point<int>, Location> map;
  final Point<int> start;
  final Point<int> end;

  Maze(this.map, this.start, this.end);
}

Future<Maze> loadData(File file) async {
  final lines = await file.readAsLines();

  Map<Point<int>, Location> maze = {};
  Point<int>? start;
  Point<int>? end;
  for (int y = 0; y < lines.length; y++) {
    final line = lines[y].split('');
    for (int x = 0; x < line.length; x++) {
      final location = switch (line[x]) {
        'S' => Location.start,
        'E' => Location.end,
        '#' => Location.wall,
        '.' => Location.empty,
        _ => throw Exception('Unexpected character ${line[x]}'),
      };
      maze[Point(x, y)] = location;

      if (location == Location.start) {
        assert(start == null, 'More than one start found');
        start = Point(x, y);
      } else if (location == Location.end) {
        assert(end == null, 'More than one end found');
        end = Point(x, y);
      }
    }
  }

  assert(start != null, 'Did not find start');
  assert(end != null, 'Did not find end');
  return Maze(maze, start!, end!);
}
