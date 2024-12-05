import 'dart:io';

import 'package:path/path.dart' as path;

enum ResourceType {
  sample,
  real;
}

enum Day {
  day1,
  day2,
  day3,
  day4;
}

final class Resources {
  final ResourceType type;

  Resources(this.type);

  static Resources get sample => Resources(ResourceType.sample);

  static Resources get real => Resources(ResourceType.real);

  File file(Day day) => _resolveFile(day);

  File _resolveFile(Day day) {
    final folder = switch (type) {
      ResourceType.sample => 'sample_data',
      ResourceType.real => 'real_data'
    };
    return File(path.join('resources', folder, '${day.name}.txt'));
  }
}
