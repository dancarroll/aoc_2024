import 'dart:io';

import 'package:collection/collection.dart';

import 'shared.dart';

final setEquality = const SetEquality<String>();
final setEquals = setEquality.equals;

/// Solution for Part 2 using the Bron–Kerbosch algorithm.
/// https://en.wikipedia.org/wiki/Bron%E2%80%93Kerbosch_algorithm
Future<String> calculate(File file) async {
  final network = await loadData(file);

  final maxClique = bronKerbosch<String>(network);

  return maxClique.sorted().join(',');
}

Set<T> bronKerbosch<T>(Map<T, Set<T>> graph) {
  List<Set<T>> cliques = [];
  internalBronKerbosch<T>(graph, {}, graph.keys.toSet(), {}, cliques);

  return cliques.reduce(
      (value, element) => (value.length > element.length) ? value : element);
}

void internalBronKerbosch<T>(
    Map<T, Set<T>> graph, Set<T> r, Set<T> p, Set<T> x, List<Set<T>> cliques) {
  if (p.isEmpty && x.isEmpty) {
    cliques.add(r);
    return;
  }

  final pivot = p.union(x).first;

  for (final vertex in p.difference(graph[pivot]!)) {
    internalBronKerbosch(
        graph,
        r.union({vertex}),
        p.intersection(graph[vertex]!),
        x.intersection(graph[vertex]!),
        cliques);

    p.remove(vertex);
    x.add(vertex);
  }
}
