import 'package:aoc_2024/lib.dart';

/// Represents the data for this problem, which is a list of
/// rules and a list of updates.
final class Contents {
  final List<Rule> rules;
  final List<Update> updates;

  Contents({required this.rules, required this.updates});
}

/// Represents a page rule, which is a declaration that a
/// given page number must always appear before another
/// page number.
final class Rule {
  final int before;
  final int after;

  Rule({required this.before, required this.after});

  factory Rule.fromList(List<int> pages) {
    assert(pages.length == 2);
    return Rule(before: pages[0], after: pages[1]);
  }
}

/// Represents an update, which has a list of page numbers.
final class Update {
  final List<int> pages;

  Update({required this.pages});

  int get middle {
    assert(pages.length.isOdd);
    return pages[(pages.length / 2).floor()];
  }
}

/// Loads data from file, with each line represents as
/// a string in the list.
Future<Contents> loadData(Resources resources) async {
  final file = resources.file(Day.day5);
  final lines = await file.readAsLines();

  final rules = <Rule>[];
  final updates = <Update>[];

  // Tracker whether we are parsing updates. If false, we
  // are still parsing rules.
  var parsingUpdates = false;

  for (final line in lines) {
    if (parsingUpdates) {
      updates.add(
          Update(pages: line.split(',').map((s) => int.parse(s)).toList()));
    } else if (line == '') {
      parsingUpdates = true;
    } else {
      rules.add(
          Rule.fromList(line.split('|').map((s) => int.parse(s)).toList()));
    }
  }

  return Contents(rules: rules, updates: updates);
}
