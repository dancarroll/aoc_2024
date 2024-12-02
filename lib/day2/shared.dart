import 'package:aoc_2024/lib.dart';

final class Report {
  final List<int> levels;

  Report(this.levels) {
    assert(levels.length > 1);
  }

  bool isSafe() {
    int? comp;
    var last = levels[0];

    for (var i = 1; i < levels.length; i++) {
      // Any jump greater than 3 is unsafe.
      if ((last - levels[i]).abs() > 3) {
        return false;
      }

      // Ensure values only ever increase or decrease, based on the
      // initial change.
      var result = last.compareTo(levels[i]);
      if (comp == null && comp != 0) {
        comp = result;
        last = levels[i];
      } else if (comp == result) {
        last = levels[i];
      } else {
        return false;
      }
    }

    return true;
  }

  /// Tests whether this report would be considered safe if any single
  /// level was removed.
  bool isSafeWithOneRemovedLevel() {
    for (var i = 0; i < levels.length; i++) {
      final testLevels = List<int>.from(levels);
      testLevels.removeAt(i);

      if (Report(testLevels).isSafe()) {
        return true;
      }
    }

    return false;
  }
}

Future<List<Report>> loadData(Resources resources) async {
  final file = resources.file(Day.day2);
  final lines = await file.readAsLines();

  final List<Report> reports = [];

  for (final line in lines) {
    reports.add(Report(line.split(' ').map((s) => int.parse(s)).toList()));
  }

  return reports;
}
