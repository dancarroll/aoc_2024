import 'package:aoc_2024/lib.dart';
import 'package:aoc_2024/day4/part_1.dart' as part1;
import 'package:aoc_2024/day4/part_2.dart' as part2;

Future<void> main(List<String> arguments) async {
  await runDay(day: 4, part1: part1.calculate, part2: part2.calculate);
}
