import 'package:aoc_2024/lib.dart';
import 'package:aoc_2024/day23/part_1.dart' as part1;
import 'package:aoc_2024/day23/part_2.dart' as part2;
import 'package:aoc_2024/day23/part_2bk.dart' as part2_bk;

Future<void> main(List<String> arguments) async {
  await runDay(
    day: Day.day23,
    part1: part1.calculate,
    part2: part2.calculate,
    additional: [
      (description: '2 (Bron–Kerbosch)', function: part2_bk.calculate),
    ],
  );
}
