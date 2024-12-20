import 'package:aoc_2024/lib.dart';
import 'package:aoc_2024/day19/part_1.dart' as part1;

Future<void> main(List<String> arguments) async {
  await runDay(
    day: Day.day19,
    part1: part1.calculate,
    part2: (_) => Future.value(0),
  );
}
