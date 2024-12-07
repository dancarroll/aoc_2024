import 'package:aoc_2024/lib.dart';

import 'shared.dart';

/// Calculate the number of safe reports in a list of
/// reports, allowing for one "bad" level.
///
/// A report is safe if the values only ever increase or
/// decrease, and no step is greater than 3. A report is
/// also safe if it follows those properties with any
/// single level removed.
Future<int> calculate(Resources resources) async {
  final reports = await loadData(resources);
  return reports.where((report) => report.isSafeWithOneRemovedLevel()).length;
}
