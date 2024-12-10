import 'package:aoc_2024/lib.dart';
import 'package:aoc_2024/day9/part_1.dart' as part1;
import 'package:aoc_2024/day9/part_2.dart' as part2;

Future<void> main(List<String> arguments) async {
  await runDay(
    day: Day.day9,
    part1: part1.calculate,
    part2: part2.calculate,
  );

  // Two stress-test inputs shared in this Reddit post:
  // https://www.reddit.com/r/adventofcode/comments/1haauty/2024_day_9_part_2_bonus_test_case_that_might_make/
  await runFile(
      file: Resources.fun.fileByName('day9_hell'),
      func: part2.calculate,
      part: 'evil_input');
  await runFile(
      file: Resources.fun.fileByName('day9_hell2'),
      func: part2.calculate,
      part: 'really_evil_input');
}
