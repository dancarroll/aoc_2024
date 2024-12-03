import 'package:aoc_2024/lib.dart';

abstract class Instruction {}

final class Do extends Instruction {}

final class Dont extends Instruction {}

final class Mult extends Instruction {
  final int first;
  final int second;

  Mult(String firstStr, String secondStr)
      : first = int.parse(firstStr),
        second = int.parse(secondStr);

  int get product => first * second;
}

Instruction parseInstruction(RegExpMatch match) {
  if (match.namedGroup('mult') != null) {
    return Mult(match.namedGroup('first').toString(),
        match.namedGroup('second').toString());
  } else if (match.namedGroup('dont') != null) {
    return Dont();
  } else if (match.namedGroup('do') != null) {
    return Do();
  }

  throw Exception('unexpected group');
}

List<Instruction> parseLine(String line) {
  final regex = RegExp(
      // First group: match `mul(123, 456)`
      r'(?<mult>mul\((?<first>\d{1,3}),(?<second>\d{1,3})\))'
      // Second group: match `don't()`
      r"|(?<dont>don't\(\))"
      // Third group: match `do()`
      r'|(?<do>do\(\))');

  return regex.allMatches(line).map((m) => parseInstruction(m)).toList();
}

Future<List<Instruction>> loadData(Resources resources) async {
  final file = resources.file(Day.day3);
  final lines = await file.readAsLines();

  return lines.map((l) => parseLine(l)).reduce((v, e) => v..addAll(e));
}
