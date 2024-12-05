import 'package:aoc_2024/lib.dart';

Future<List<String>> loadData(Resources resources) async {
  final file = resources.file(Day.day4);
  return file.readAsLines();
}
