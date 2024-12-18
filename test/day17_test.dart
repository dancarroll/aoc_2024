import 'package:aoc_2024/day17/shared.dart';
import 'package:aoc_2024/lib.dart';
import 'package:aoc_2024/day17/part_1.dart' as part1;
import 'package:test/test.dart';

void main() {
  final day = Day.day17;

  group('sample data', tags: 'sample-data', () {
    final resources = Resources.sample;
    final file = resources.file(day);

    test('part1', () async {
      expect(await part1.calculate(file), '4,6,3,5,6,3,5,2,1,0');
    });
  });

  group('real data', tags: 'real-data', () {
    final resources = Resources.real;
    final file = resources.file(day);

    test('part1', () async {
      expect(await part1.calculate(file), '2,1,4,0,7,4,0,2,3');
    });
  });

  group('other day', tags: 'sample-data', () {
    test('part 2 example', () {
      // This input is given as a sample in the Part 2 test, to show the minimum
      // value necessary to have the program product itself.
      final computer = loadDataFromLines([
        'Register A: 117440',
        'Register B: 0',
        'Register C: 0',
        '',
        'Program: 0,3,5,4,3,0',
      ]);

      expect(part1.executeComputer(computer), '0,3,5,4,3,0');
    });
  });
}
