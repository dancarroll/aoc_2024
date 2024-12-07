import 'dart:math';

import 'package:aoc_2024/lib.dart';

enum Operators {
  add,
  multiply;
}

class Component {}

abstract class Operator extends Component {}

class Add extends Operator {
  @override
  String toString() => '+';
}

class Multiply extends Operator {
  @override
  String toString() => '*';
}

class Identity extends Operator {}

class Value extends Component {
  final int num;

  Value(this.num);

  @override
  String toString() => num.toString();
}

final class Equation {
  final int result;
  final List<Component> components;

  Equation({required this.result, required this.components});

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
        }
      }
    }

    return computedResult == result;
  }

  @override
  String toString() =>
      '$result: ${components.map((c) => c.toString()).join(' ')}';
}

final class AmbiguousEquation {
  final int result;
  final List<int> operands;

  AmbiguousEquation({required this.result, required this.operands});

  List<Equation> get potentialEquations {
    // 1 2 3 4
    // 3 operators
    // + + +
    // + + *
    // + * *
    // * * *
    // * + +
    // * * +
    // * + *
    // + * +
    List<List<Operator>> operatorOptions = [];
    _generateOperators(
        operands.length - 1, [Add(), Multiply()], operatorOptions, 0, []);
    assert(operatorOptions.length == pow(2, operands.length - 1));

    //for (final operatorList in operatorOptions) {
    //  print(operatorList);
    //}
    return operatorOptions.map((operators) {
      var components = <Component>[];
      for (int i = 0; i < operands.length; i++) {
        components.add(Value(operands[i]));
        if (i < operators.length) {
          components.add(operators[i]);
        }
      }
      return Equation(result: result, components: components);
    }).toList();
  }

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
Future<List<AmbiguousEquation>> loadData(Resources resources) async {
  final file = resources.file(Day.day7);
  final lines = await file.readAsLines();

  return lines.map((line) {
    final components = line.split(':');
    assert(components.length == 2);

    final result = int.parse(components[0]);
    final operands =
        components[1].trim().split(' ').map((s) => int.parse(s)).toList();

    return AmbiguousEquation(result: result, operands: operands);
  }).toList();
}
