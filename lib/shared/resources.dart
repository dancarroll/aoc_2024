import 'dart:io';

import 'package:path/path.dart' as path;

/// Represents the different resource types available.
enum ResourceType {
  /// The sample test input, which is the same for all
  /// participants.
  sample,

  /// The real test input, which is unique per participant
  /// (and is not checked into the repository, following
  /// AOC guidelines).
  real;
}

/// Represents each day in Advent of Code 2024.
enum Day {
  day1,
  day2,
  day3,
  day4,
  day5,
  day6,
  day7;
}

/// Manager for loading a resource file, based on type and day.
final class Resources {
  final ResourceType type;

  Resources(this.type);

  static Resources get sample => Resources(ResourceType.sample);

  static Resources get real => Resources(ResourceType.real);

  /// Create a file reference for the given day.
  File file(Day day) {
    final folder = switch (type) {
      ResourceType.sample => 'sample_data',
      ResourceType.real => 'real_data'
    };
    return File(path.join('resources', folder, '${day.name}.txt'));
  }

  @override
  String toString() => type.name;
}
