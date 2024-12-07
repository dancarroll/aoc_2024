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

  /// Returns true if any combination of the given operators would result
  /// in this equation being valid.
  bool canBeValid(List<Operator> operators) {
    List<List<Operator>> operatorCombinatorial = [];
    return _generateValidOperators(
        operands.length - 1, operators, operatorCombinatorial, 0, []);
  }

  /// Recursively generates a list of operator combinations and determines if
  /// any result in a valid equation.
  bool _generateValidOperators(int length, List<Operator> operators,
      List<List<Operator>> result, int depth, List<Operator> current) {
    if (depth == length) {
      var components = <Component>[];
      for (int i = 0; i < operands.length; i++) {
        components.add(Value(operands[i]));
        if (i < current.length) {
          components.add(current[i]);
        }
      }
      final equation = Equation(result: this.result, components: components);
      return equation.isValid();
    }

    return operators.any((operator) => _generateValidOperators(
        length, operators, result, depth + 1, [...current, operator]));
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
