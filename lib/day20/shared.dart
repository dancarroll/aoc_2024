import 'dart:io';
import 'dart:math';

extension ManhattanDistance on Point<int> {
  int manhattanDistance(Point<int> other) {
    return (x - other.x).abs() + (y - other.y).abs();
  }
}

/// Represents a location within the maze.
enum Location {
  wall,
  empty,
  start,
  end;
}

/// Represents a maze in the "race condition festival".
final class Maze {
  /// Maze representation, which is just a map of points to their types.
  final Map<Point<int>, Location> map;

  /// Reference to the starting point.
  final Point<int> start;

  /// Reference to the ending point.
  final Point<int> end;

  Maze(this.map, this.start, this.end);
}

/// Represents a heading in the maze.
enum Heading {
  up,
  right,
  down,
  left;

  /// Calculates the new point based on a given point and this heading.
  Point<int> move(Point<int> point) => switch (this) {
        up => Point(point.x, point.y - 1),
        down => Point(point.x, point.y + 1),
        left => Point(point.x - 1, point.y),
        right => Point(point.x + 1, point.y)
      };
}

/// Represents a candidate for the best path in the maze.
final class CandidatePath implements Comparable<CandidatePath> {
  /// Static counter the increments for every created candidate path.
  /// This is used for a simple comparison during equality checking.
  static int _pathCounter = 0;

  /// Set of all points visited in this path so far.
  final List<Point<int>> visited;

  /// Current position along this path.
  Point<int> current;

  /// Unique index of the path
  final int _index;

  CandidatePath(this.visited, this.current) : _index = _pathCounter++;

  /// Creates a new candidate from an existing candidate, by copying its
  /// list of visited points and steps.
  factory CandidatePath.fromCandidate(CandidatePath other) {
    return CandidatePath(
      [...other.visited],
      other.current,
    );
  }

  /// Returns the current score of this path.
  int get score => visited.length - 1;

  /// Incorporates the given [nextStep] along this path, including updating
  /// the path score.
  void step(Point<int> point) {
    // Track that the next position has been visited, and is the new current.
    current = point;
    visited.add(point);
  }

  @override
  int get hashCode => _index;

  @override
  bool operator ==(Object other) =>
      (other is CandidatePath) ? _index == other._index : false;

  @override
  int compareTo(CandidatePath other) => score.compareTo(other.score);
}

/// Finds all of the lowest cost paths through the given maze.
List<CandidatePath> findAllPaths(Maze maze) {
  // Prime the list of candidate paths with the starting point.
  final paths = [
    CandidatePath([maze.start], maze.start)
  ];
  final completedPaths = <CandidatePath>[];

  // Iterate until all paths have been processed (since we are not stopping once
  // the shortest path has been identified).
  while (paths.isNotEmpty) {
    final path = paths[0];

    if (path.current == maze.end) {
      paths.remove(path);
      completedPaths.add(path);
      continue;
    }

    // Find all of the possible next steps along the current path.
    final nextSteps = _getValidStepsFromPoint(
        maze: maze, current: path.current, visited: path.visited);
    if (nextSteps.isNotEmpty) {
      // For any additional valid steps, branch off a new candidate path.
      for (int i = 1; i < nextSteps.length; i++) {
        final newCandidate = CandidatePath.fromCandidate(path);
        newCandidate.step(nextSteps[i]);
        paths.add(newCandidate);
      }

      // Use the first step option on the current candidate path.
      // This is done after adding the new candidate paths, since the logic
      // above copies this path's list of steps/visited.
      path.step(nextSteps[0]);
    } else {
      // No additional steps along this path, so prune it. A path that already
      // reached the end would have been checked earlier.
      paths.remove(path);
    }
  }

  return completedPaths;
}

/// Determines all of the valid next steps from a given path.
///
/// Rather than accepting a [CandidatePath], this function just accepts the
/// reindeer position and a set of visited points.
///
/// In reality, this function should never return more than 3 points (since
/// only moves in cardinal directions are allowed, and one of those 4 directions
/// would have already been visited).
List<Point<int>> _getValidStepsFromPoint(
    {required Maze maze,
    required Point<int> current,
    required List<Point<int>> visited}) {
  // Given the only potential moves (straight, clockwise, counterclockwise)
  return Heading.values
      .map((h) => h.move(current))
      // Filter out any steps outside the bounds of the maze.
      .where((p) => maze.map.containsKey(p))
      // Filter out any step that would visit a visited point.
      .where((p) => !visited.contains(p))
      // Limit to steps that would land on empty spaces or the end.
      // If a cheat is allowed, also include spaces that would move onto a wall.
      .where((p) => switch (maze.map[p]) {
            Location.empty => true,
            Location.end => true,
            _ => false,
          })
      // Convert to a list (since it will later be indexed).
      .toList();
}

/// Compute the savings from each unique cheat.
List<int> uniqueCheatSavings(List<Point<int>> path, int maxCheatLength) {
  // Keep track of the length to the end from each point.
  Map<Point<int>, int> pathLength = {};
  for (int i = 0; i < path.length; i++) {
    pathLength[path[i]] = path.length - i - 1;
  }

  // Now, iterate through each potential cheat from each point on the map, and
  // calculate the savings.
  List<int> savings = [];
  for (final point in path) {
    for (final jumpToPoint in path
        .where((p) =>
            p.manhattanDistance(point) >= 2 &&
            p.manhattanDistance(point) <= maxCheatLength)
        .where((p) => pathLength[p]! < (path.length - 1))) {
      final savingsWithCheat = pathLength[point]! -
          pathLength[jumpToPoint]! -
          point.manhattanDistance(jumpToPoint);
      if (savingsWithCheat > 0) {
        savings.add(savingsWithCheat);
      }
    }
  }
  return savings;
}

/// Loads the data for a maze from a file.
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

      // If we processed a start/end, save it off.
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
