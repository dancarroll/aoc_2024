import 'package:aoc_2024/lib.dart';
import 'package:collection/collection.dart';

import 'shared.dart';

/// Parse a list of page rules (before/after page number pairs),
/// and a list of updates (sequence of page numbers).
///
/// For each valid update, extract the middle page number from the
/// update, and add all of those numbers together.
Future<int> calculate(Resources resources) async {
  final contents = await loadData(resources);
  final graph = _loadRulesIntoGraph(contents.rules);

  return contents.updates
      .where((update) => _isUpdateValid(graph: graph, update: update))
      .map((update) => update.middle)
      .reduce((v, e) => v+e);
}

final class Node {
  final int page;
  final List<Node> after = [];

  Node({required this.page});
}

Map<int, Node> _loadRulesIntoGraph(List<Rule> rules) {
  final graph = <int, Node>{};

  for (final rule in rules) {
    final beforeNode =
        graph.putIfAbsent(rule.before, () => Node(page: rule.before));
    final afterNode =
        graph.putIfAbsent(rule.after, () => Node(page: rule.after));

    beforeNode.after.add(afterNode);
  }

  return graph;
}

bool _isUpdateValid(
    {required final Map<int, Node> graph, required final Update update}) {
  var node = graph[update.pages[0]];

  var i = 0;
  while (node != null && i < update.pages.length - 1) {
    i++;
    final page = update.pages[i];
    node = node.after.firstWhereOrNull((n) => n.page == page);
  }

  return (node != null) && i >= update.pages.length - 1;
}
