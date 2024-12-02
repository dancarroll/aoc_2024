import 'package:aoc_2024/lib.dart';

import 'shared.dart';

Future<int> calculate(Resources resources) async {
  final reports = await loadData(resources);
  return reports
      .where((report) => report.isSafe())
      .length;
}
