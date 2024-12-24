import 'dart:io';

import 'package:collection/collection.dart';

import 'shared.dart';

final setEquality = const SetEquality<String>();
final setEquals = setEquality.equals;

/// Solution for Part 2 using the Bron–Kerbosch algorithm.
/// https://en.wikipedia.org/wiki/Bron%E2%80%93Kerbosch_algorithm
Future<String> calculate(File file) async {
  final network = await loadData(file);

  return '';
}
