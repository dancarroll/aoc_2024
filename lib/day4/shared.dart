import 'package:aoc_2024/lib.dart';

/// Loads data from file, with each line represents as
/// a string in the list.
Future<List<String>> loadData(Resources resources) async {
  final file = resources.file(Day.day4);
  return file.readAsLines();
}
