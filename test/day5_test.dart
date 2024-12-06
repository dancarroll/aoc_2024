import 'package:aoc_2024/lib.dart';
import 'package:aoc_2024/day5/part_1.dart' as part1;
import 'package:aoc_2024/day5/part_2.dart' as part2;
import 'package:test/test.dart';

void main() {
  group('sample data', () {
    final resources = Resources.sample;

    test('part1', () async {
      expect(await part1.calculate(resources), 143);
    });

    test('part2', () async {
      expect(await part2.calculate(resources), 123);
    });
  });

  group('real data', () {
    final resources = Resources.real;

    test('part1', () async {
      expect(await part1.calculate(resources), 4790);
    });

    test('part2', () async {
      expect(await part2.calculate(resources), 6319);
    });
  });
}
