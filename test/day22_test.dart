import 'package:aoc_2024/lib.dart';
import 'package:aoc_2024/day22/part_1.dart' as part1;
import 'package:test/test.dart';

void main() {
  final day = Day.day22;

  group('sample data', tags: 'sample-data', () {
    final resources = Resources.sample;
    final file = resources.file(day);

    test('part1', () async {
      expect(await part1.calculate(file), 37327623);
    });
  });

  group('real data', tags: 'real-data', () {
    final resources = Resources.real;
    final file = resources.file(day);

    test('part1', () async {
      expect(await part1.calculate(file), 15608699004);
    });
  });
}
