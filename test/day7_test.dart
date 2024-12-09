import 'package:aoc_2024/lib.dart';
import 'package:aoc_2024/day7/part_1.dart' as part1;
import 'package:aoc_2024/day7/part_2.dart' as part2;
import 'package:test/test.dart';

void main() {
  final day = Day.day7;

  group('sample data', tags: 'sample-data', () {
    final resources = Resources.sample;
    final file = resources.file(day);

    test('part1', () async {
      expect(await part1.calculate(file), 3749);
    });

    test('part2', () async {
      expect(await part2.calculate(file), 11387);
    });
  });

  group('real data', tags: 'real-data', () {
    final resources = Resources.real;
    final file = resources.file(day);

    test('part1', () async {
      expect(await part1.calculate(file), 4998764814652);
    });

    test('part2', () async {
      expect(await part2.calculate(file), 37598910447546);
    });
  });
}
