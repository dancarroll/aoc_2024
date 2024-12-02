import 'package:aoc_2024/lib.dart';
import 'package:aoc_2024/day1/part_1.dart' as part1;
import 'package:aoc_2024/day1/part_2.dart' as part2;

void main(List<String> arguments) async {
  print('Advent of Code - Day 1');
  print('Part 1: ${await part1.calculate(Resources.real)}');
  print('Part 2: ${await part2.calculate(Resources.real)}');
}

