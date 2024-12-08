import 'package:aoc_2024/lib.dart';

import 'shared.dart';

/// Given a list of equations without operators, determine which
/// equations could be valid, and return the sum of all equations
/// which could be valid.
///
/// Equations are given of the form:
/// 3267: 81 40 27
///
/// The first value is the equation result, and the remaining value
/// are the equation operands. The only valid operators are add (`+`)
/// and multiply (`*`).
Future<int> calculate(Resources resources) async {
  final equations = await loadData(resources);

  final result = equations
      .where((e) => _canEquationBeTrue(e))
      .fold(0, (v, e) => v + e.result);
  return result;
}

bool _canEquationBeTrue(final AmbiguousEquation equation) =>
    equation.canBeValid([
      Add(),
      Multiply(),
    ]);
