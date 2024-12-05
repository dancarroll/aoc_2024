import 'package:aoc_2024/lib.dart';

import 'shared.dart';

/// Parse a list of page rules (before/after page number pairs),
/// and a list of updates (sequence of page numbers).
///
/// For each valid update, extract the middle page number from the
/// update, and add all of those numbers together.
Future<int> calculate(Resources resources) async {
  final contents = await loadData(resources);

  return contents.updates
      .where((update) => update.isValid(rules: contents.rules))
      .map((update) => update.middle)
      .reduce((v, e) => v+e);
}

