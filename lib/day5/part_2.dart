import 'package:aoc_2024/lib.dart';

import 'shared.dart';

/// Following from Part 1, find the updates that are not valid,
/// fix them to make them valid, then find and add up all of the
/// middle numbers.
Future<int> calculate(Resources resources) async {
  final contents = await loadData(resources);

  return contents.updates
      .where((update) => !update.isValid(rules: contents.rules))
      .map((update) => update..sortViaRules(rules: contents.rules))
      .map((update) => update.middle)
      .reduce((v, e) => v + e);
}
