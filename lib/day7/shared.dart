import 'dart:math';

import 'package:aoc_2024/lib.dart';

/// Represents an arbitrary equation component.
abstract class Component {}

/// Represents an operator within an equation.
abstract class Operator extends Component {}

/// Addition operator.
class Add extends Operator {
  @override
  String toString() => '+';
}

/// Multiplication operator.
class Multiply extends Operator {
  @override
  String toString() => '*';
}

/// Concatenation operator (concatenates the numbers on
/// the left and right side to make a new number).
class Concatenation extends Operator {
  @override
  String toString() => '||';
}

/// Identity operator, which just copies the next number in
/// the equation.
class Identity extends Operator {}

/// Represents a numerical value operand.
class Value extends Component {
  final int num;

  Value(this.num);

  @override
  String toString() => num.toString();
}

/// Represents an equation, which may or may not be valid.
final class Equation {
  final int result;
  final List<Component> components;

  Equation({required this.result, required this.components});

  /// Computes the result of the equation, and returns true if the value
  /// matches the equations stated result.
  bool isValid() {
    var computedResult = 0;
    Operator operator = Identity();

    for (final component in components) {
      if (component is Operator) {
        operator = component;
      } else if (component is Value) {
        switch (operator.runtimeType) {
          case == Identity:
            computedResult = component.num;
          case == Add:
            computedResult += component.num;
          case == Multiply:
            computedResult *= component.num;
          case == Concatenation:
            computedResult = int.parse('$computedResult${component.num}');
        }
      }
    }

    return computedResult == result;
  }

  @override
  String toString() =>
      '$result: ${components.map((c) => c.toString()).join(' ')}';
}

/// Represents an ambiguous equation, which has a list of operands
/// but no operators.
final class AmbiguousEquation {
  final int result;
  final List<int> operands;

  AmbiguousEquation({required this.result, required this.operands});

  /// Generates a list of all potential equations from the operands
  /// in this equation, based on the given list of operators.
  Iterable<Equation> potentialEquations(List<Operator> operators) {
    List<List<Operator>> operatorCombinatorial = [];
    _generateOperators(
        operands.length - 1, operators, operatorCombinatorial, 0, []);
    assert(operatorCombinatorial.length ==
        pow(operators.length, operands.length - 1));

    return operatorCombinatorial.map((operators) {
      var components = <Component>[];
      for (int i = 0; i < operands.length; i++) {
        components.add(Value(operands[i]));
        if (i < operators.length) {
          components.add(operators[i]);
        }
      }
      return Equation(result: result, components: components);
    });
  }

  /// Recursively generates a list of operator combinations.
  void _generateOperators(int length, List<Operator> operators,
      List<List<Operator>> result, int depth, List<Operator> current) {
    if (depth == length) {
      result.add(current);
      return;
    }

    for (int i = 0; i < operators.length; i++) {
      _generateOperators(
          length, operators, result, depth + 1, [...current, operators[i]]);
    }
  }
}

/// Loads data from file, with each line represents as
/// an equation.
Future<Iterable<AmbiguousEquation>> loadData(Resources resources) async {
  final file = resources.file(Day.day7);
  final lines = await file.readAsLines();

  return lines.map((line) {
    final components = line.split(':');
    assert(components.length == 2);

    final result = int.parse(components[0]);
    final operands =
        components[1].trim().split(' ').map((s) => int.parse(s)).toList();

    return AmbiguousEquation(result: result, operands: operands);
  });
}
