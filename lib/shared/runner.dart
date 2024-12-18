import 'dart:io';

import 'resources.dart';

typedef DayFunction = Future<dynamic> Function(File);

final _stopwatch = Stopwatch();

/// Runs both parts for a day, and prints their output as well as the
/// elapsed time to run each part.
Future<void> runDay(
    {required final Day day,
    required final DayFunction part1,
    required final DayFunction part2,
    runSample = true,
    runReal = true}) async {
  print('Advent of Code - Day ${day.number}');
  for (final resource in [
    if (runSample) Resources.sample,
    if (runReal) Resources.real
  ]) {
    print('- $resource data:');

    for (final part in [('1', part1), ('2', part2)]) {
      final file = resource.file(day);
      await runFile(file: file, func: part.$2, part: part.$1);
    }
  }
}

Future<void> runFile(
    {required final File file,
    required final DayFunction func,
    required final String part}) async {
  _stopwatch.reset();
  _stopwatch.start();
  final result = await func(file);
  _stopwatch.stop();

  print('  - Part $part: $result  (${_stopwatch.elapsedMilliseconds}ms)');
}
