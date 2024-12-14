import 'dart:io';
import 'dart:math';

typedef Position = Point<int>;
typedef Velocity = Point<int>;

/// Represent a single robot's position and velocity.
final class Robot {
  /// Robot's current position.
  Position pos;

  // Robot's velocity. This can never change.
  final Velocity velo;

  Robot(this.pos, this.velo);

  @override
  String toString() => 'Position: $pos, Velocity: $velo';
}

/// Loads a list of robot positions and velocities from a file.
Future<List<Robot>> loadData(File file) async {
  final lines = await file.readAsLines();

  List<Robot> robots = [];
  final lineRegex =
      RegExp(r'^p=(?<px>\d+),(?<py>\d+) v=(?<vx>-?\d+),(?<vy>-?\d+)$');
  for (final line in lines) {
    final match = lineRegex.firstMatch(line)!;
    match.namedGroup('px');
    robots.add(Robot(
        Point(
          toInt(match.namedGroup('px')),
          toInt(match.namedGroup('py')),
        ),
        Point(
          toInt(match.namedGroup('vx')),
          toInt(match.namedGroup('vy')),
        )));
  }

  return robots;
}

/// Parses a nullable string as an integer, throwing an error if the string
/// is actually null.
int toInt(String? str) {
  if (str == null) throw ArgumentError.notNull('str');
  return int.parse(str);
}
