import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

import 'shared.dart';

enum Step {
  straight,
  turn;
}

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

  Heading rotateClockwise() {
    var nextIndex = index + 1;
    if (nextIndex >= Heading.values.length) {
      nextIndex = 0;
    }
    return Heading.values[nextIndex];
  }

  Heading rotateCounterclockwise() {
    var nextIndex = index - 1;
    if (nextIndex < 0) {
      nextIndex = Heading.values.length - 1;
    }
    return Heading.values[nextIndex];
  }
}

typedef ReindeerLocation = ({Heading heading, Point<int> point});
typedef NextStep = ({Step step, ReindeerLocation location});

int pathCounter = 0;

final class CandidatePath implements Comparable<CandidatePath> {
  final Set<Point<int>> visited;
  final List<Step> steps;
  ReindeerLocation current;
  final int _index;
  int _score;

  CandidatePath(this.visited, this.steps, this.current, {score = 0})
      : _index = pathCounter++,
        _score = score;

  factory CandidatePath.fromCandidate(CandidatePath other) {
    return CandidatePath(
      {...other.visited},
      [...other.steps],
      other.current,
      score: other._score,
    );
  }

  // int get score => steps.fold(
  //     0, (v, e) => v + switch (e) { Step.straight => 1, Step.turn => 1000 });
  int get score => _score;

  void step(NextStep nextStep) {
    current = nextStep.location;
    visited.add(nextStep.location.point);

    switch (nextStep.step) {
      case Step.straight:
        steps.add(nextStep.step);
        _score += 1;
      case Step.turn:
        // Any turn is really two steps: a turn, followed by moving straight
        // into the new location.
        steps.add(nextStep.step);
        steps.add(Step.straight);
        _score += 1001;
    }
  }

  @override
  int get hashCode => _index;

  @override
  bool operator ==(Object other) {
    if (other is CandidatePath) {
      return _index == other._index;
    } else {
      return false;
    }
  }

  @override
  int compareTo(CandidatePath other) {
    return score.compareTo(other.score);
  }
}

final class SortedList<T extends Comparable> extends DelegatingList<T> {
  SortedList() : super(<T>[]);

  @override
  void add(T value) {
    int i = 0;
    while (i < super.length && super[i].compareTo(value) < 0) {
      i++;
    }
    super.insert(i, value);
  }

  @override
  void addAll(Iterable<T> iterable) {
    throw UnimplementedError();
  }

  @override
  List<T> operator +(List<T> other) {
    throw UnimplementedError();
  }
}

/// --- Day 16: Reindeer Maze ---
///
/// TBD
Future<int> calculate(File file) async {
  final maze = await loadData(file);

  print(maze.start);
  print(maze.map.keys.length);

  // Prime the list of candidate paths.
  final paths = SortedList<CandidatePath>();
  for (final nextStep in getValidStepsFromPoint(
    maze,
    (heading: Heading.right, point: maze.start),
    {maze.start},
  )) {
    final path = CandidatePath(
        {maze.start}, [], (heading: Heading.right, point: maze.start));
    path.step(nextStep);
    paths.add(path);
  }

  // For each point encountered, store the lowest score so far.
  // If we ever have a path that reaches a point with a higher score,
  // that path can be discarded.
  Map<Point<int>, int> lowestPointScores = {};

  bool finished = false;
  mainController:
  while (!finished) {
    //finished = true;
    List<CandidatePath> pathsToPrune = [];

    //for (int pathIndex = 0; pathIndex < paths.length; pathIndex++) {
    //final path = paths[pathIndex];
    int lowestScore = paths[0].score;
    final currIterationPaths = <CandidatePath>[];
    int i = 0;
    while (i < paths.length && paths[i].score == lowestScore) {
      currIterationPaths.add(paths[i]);
      i++;
    }

    for (final path in currIterationPaths) {
      //final path = paths[0];

      if (path.current.point == maze.end) {
        //continue;
        break mainController;
      }

      if (lowestPointScores.containsKey(path.current.point)) {
        final lowestScore = lowestPointScores[path.current.point]!;
        // assert(lowestScore != path.score,
        //     "Found another path with same score to point");
        if (lowestScore < path.score) {
          pathsToPrune.add(path);
        } else if (lowestScore < path.score) {
          lowestPointScores[path.current.point] = path.score;
        }
      } else {
        lowestPointScores[path.current.point] = path.score;
      }

      final nextSteps =
          getValidStepsFromPoint(maze, path.current, path.visited);
      if (nextSteps.isNotEmpty) {
        finished = false;

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
        // No additional steps along this path, so prune it.
        pathsToPrune.add(path);
      }
    }

    for (final pathToPrune in pathsToPrune) {
      paths.remove(pathToPrune);
    }
    paths.sort();

    //finished = true;
  }

  print(paths.length);
  //paths.sort((a, b) => a.score.compareTo(b.score));

  print('Lowest score: ${paths[0].score}');
  print('Highest score: ${paths[paths.length - 1].score}');

  final bestPath = paths[0];
  print('Best: ');
  print(
      '  - Num straight: ${bestPath.steps.where((s) => s == Step.straight).length}');
  print('  - Num turns: ${bestPath.steps.where((s) => s == Step.turn).length}');
  print('');
  print(bestPath.steps);

  return 0;
}

List<NextStep> getValidStepsFromPoint(
    Maze maze, ReindeerLocation current, Set<Point<int>> visited) {
  return [
    (current.heading, Step.straight),
    (current.heading.rotateClockwise(), Step.turn),
    (current.heading.rotateCounterclockwise(), Step.turn),
  ]
      .map((h) => (
            step: h.$2,
            location: (heading: h.$1, point: h.$1.move(current.point))
          ))
      .where((ns) => !visited.contains(ns.location.point))
      .where((ns) =>
          maze.map[ns.location.point] == Location.empty ||
          maze.map[ns.location.point] == Location.end)
      .toList();
}
