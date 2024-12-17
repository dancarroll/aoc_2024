import 'day1.dart' as day1;
import 'day2.dart' as day2;
import 'day3.dart' as day3;
import 'day4.dart' as day4;
import 'day5.dart' as day5;
import 'day6.dart' as day6;
import 'day7.dart' as day7;
import 'day8.dart' as day8;
import 'day9.dart' as day9;
import 'day10.dart' as day10;
import 'day11.dart' as day11;
import 'day12.dart' as day12;
import 'day13.dart' as day13;
import 'day14.dart' as day14;
import 'day15.dart' as day15;
import 'day16.dart' as day16;

void main(List<String> arguments) async {
  print('');
  for (final day in [
    day1.main,
    day2.main,
    day3.main,
    day4.main,
    day5.main,
    day6.main,
    day7.main,
    day8.main,
    day9.main,
    day10.main,
    day11.main,
    day12.main,
    day13.main,
    day14.main,
    day15.main,
    day16.main,
  ]) {
    await day(arguments);
    print('');
  }
}
