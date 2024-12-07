import 'package:aoc_2024/lib.dart';
import 'package:aoc_2024/day7/part_1.dart' as part1;

Future<void> main(List<String> arguments) async {
  await runDay(
    day: 7,
    part1: part1.calculate,
    part2: (r) => Future.value(0),
  );
}
