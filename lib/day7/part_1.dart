import 'package:aoc_2024/lib.dart';

import 'shared.dart';

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
