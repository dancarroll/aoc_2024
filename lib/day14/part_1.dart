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

  // Prepare for tracking how many robots are in each quadrant.
  int vertSplit = width ~/ 2;
  int horiSplit = height ~/ 2;
  Map<Position, int> quadrants = {};

  for (final robot in robots) {
    // First, determine where the robot will be at 100 seconds.
    final newX = (robot.pos.x + (robot.velo.x * maxSeconds)) % width;
    final newY = (robot.pos.y + (robot.velo.y * maxSeconds)) % height;

    // Then, assign the robot to a quadrant.
    // The quadrant map keys are points normalized to 1. Points along
    // the (0,0) line are recorded here, but will not be counted later.
    quadrants.update(
        Position(
          directionalDiff(newX, vertSplit),
          directionalDiff(newY, horiSplit),
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

int directionalDiff(int i, int center) {
  int diff = i - center;
  return (diff == 0) ? 0 : diff ~/ diff.abs();
}
