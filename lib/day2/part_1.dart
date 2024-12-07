import 'package:aoc_2024/lib.dart';

import 'shared.dart';

/// Calculate the number of safe reports in a list of
/// reports.
///
/// Each report is list of integers (levels). A report is
/// safe if the values only ever increase or decrease, and
/// no step is greater than 3.
Future<int> calculate(Resources resources) async {
  final reports = await loadData(resources);
  return reports.where((report) => report.isSafe()).length;
}
