import 'day1.dart' as day1;
import 'day2.dart' as day2;
import 'day3.dart' as day3;
import 'day4.dart' as day4;
import 'day5.dart' as day5;
import 'day6.dart' as day6;
import 'day7.dart' as day7;

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
  ]) {
    await day(arguments);
    print('');
  }
}
