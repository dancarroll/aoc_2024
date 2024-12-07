import 'resources.dart';

typedef DayFunction = Future<int> Function(Resources);

final _stopwatch = Stopwatch();

/// Runs both parts for a day, and prints their output as well as the
/// elapsed time to run each part.
Future<void> runDay(
    {required final int day,
    required final DayFunction part1,
    required final DayFunction part2}) async {
  print('Advent of Code - Day $day');
  for (final resource in [Resources.sample, Resources.real]) {
    print('- $resource data:');

    for (final part in [(1, part1), (2, part2)]) {
      _stopwatch.reset();
      _stopwatch.start();
      final result = await part.$2(resource);
      _stopwatch.stop();

      print(
          '  - Part ${part.$1}: $result  (${_stopwatch.elapsedMilliseconds}ms)');
    }
  }
}
