import 'dart:io';

import 'shared.dart';

const maxSeconds = 100;

/// --- Day 14: Restroom Redoubt ---
///
/// Given a list of robot positions and velocities, determine their
/// position after 100 seconds. Then, split the robots into four
/// quadrants, count the robots in each quadrant (ignoring ones that
/// are on the line between two quadrants), and multiply those values
/// together.
Future<int> calculate(File file) async {
  final robots = await loadData(file);

  // For some reason, height and width are not in the problem's input.
  // This varies between the sample and real input, so I hacked in this
  // quick approach to vary the size of the map.
  final height = file.path.contains('real_data') ? 103 : 7;
  final width = file.path.contains('real_data') ? 101 : 11;

  // First, determine where the robots will be at 100 seconds.
  for (int seconds = 1; seconds <= maxSeconds; seconds++) {
    for (final robot in robots) {
      robot.pos = move(
        start: robot.pos,
        velo: robot.velo,
        height: height,
        width: width,
      );
    }
  }

  // Now, iterate through the robots and assign them to quadrants.
  int vertSplit = width ~/ 2;
  int horiSplit = height ~/ 2;

  Map<Position, int> quadrants = {};
  for (final robot in robots) {
    quadrants.update(
        Position(
          directionalDiff(robot.pos.x, vertSplit),
          directionalDiff(robot.pos.y, horiSplit),
        ),
        (i) => i + 1,
        ifAbsent: () => 1);
  }

  // Multiply the quadrant counts together. Ignore anything that is
  // along the lines splitting the quadrants.
  final result = quadrants.entries.fold(1, (v, e) {
    if (e.key.x == 0 || e.key.y == 0) {
      return v;
    } else {
      return v * e.value;
    }
  });

  return result;
}

Position move(
        {required Position start,
        required Velocity velo,
        required int height,
        required int width}) =>
    Position(wrap(start.x + velo.x, width), wrap(start.y + velo.y, height));

int wrap(int i, int max) {
  if (i < 0) {
    return max + i;
  } else if (i >= max) {
    return i - max;
  }
  return i;
}

int directionalDiff(int i, int center) {
  int diff = i - center;
  return (diff == 0) ? 0 : diff ~/ diff.abs();
}
