import 'package:aoc_2024/lib.dart';

final class Mult {
  final int first;
  final int second;

  Mult(String firstStr, String secondStr)
      : first = int.parse(firstStr),
        second = int.parse(secondStr);

  int get product => first * second;
}

List<Mult> parseLine(String line) {
  final regex = RegExp(r'mul\((?<first>\d{1,3}),(?<second>\d{1,3})\)');

  return regex
      .allMatches(line)
      .map((m) => Mult(
          m.namedGroup('first').toString(), m.namedGroup('second').toString()))
      .toList();
}

Future<List<Mult>> loadData(Resources resources) async {
  final file = resources.file(Day.day3);
  final lines = await file.readAsLines();

  return lines.map((l) => parseLine(l)).reduce((v, e) => v..addAll(e));
}
