import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:quiver/collection.dart';

final class NumericKeypad {
  BiMap<Point<int>, String> layout;
  Point<int> location;

  NumericKeypad._(this.layout, this.location);

  factory NumericKeypad.standard() {
    return NumericKeypad._(
        BiMap()
          ..addAll(
            {
              Point(0, 0): '7',
              Point(1, 0): '8',
              Point(2, 0): '9',
              Point(0, 1): '4',
              Point(1, 1): '5',
              Point(2, 1): '6',
              Point(0, 2): '1',
              Point(1, 2): '2',
              Point(2, 2): '3',
              Point(0, 3): 'X',
              Point(1, 3): '0',
              Point(2, 3): 'A',
            },
          ),
        // Start out pointing at the A button.
        Point(2, 3));
  }

  Point<int> buttonLocation(String char) => layout.inverse[char]!;

  /// Returns all of the combinations of steps from the starting point to given
  /// keypad character.
  List<List<DirectionalButton>> stepCombinationsTo(
          Point<int> starting, String char) =>
      generateStepCombinationsTo(
          starting, layout.inverse[char]!, layout, (c) => c != 'X');
}

typedef Direction = ({DirectionalButton direction, Point<int> step});

enum DirectionalButton {
  up,
  right,
  down,
  left,
  none,
  activate;

  @override
  String toString() => switch (this) {
        up => '^',
        right => '>',
        down => 'v',
        left => '<',
        activate => 'A',
        _ => throw Exception('unexpected direction'),
      };

  static List<Direction> get directions => [
        (direction: DirectionalButton.up, step: Point(0, -1)),
        (direction: DirectionalButton.right, step: Point(1, 0)),
        (direction: DirectionalButton.down, step: Point(0, 1)),
        (direction: DirectionalButton.left, step: Point(-1, 0)),
      ];
}

final class DirectionalKeypad {
  BiMap<Point<int>, DirectionalButton> layout;
  Point<int> location;

  DirectionalKeypad._(this.layout, this.location);

  factory DirectionalKeypad.standard() {
    return DirectionalKeypad._(
        BiMap()
          ..addAll(
            {
              Point(0, 0): DirectionalButton.none,
              Point(1, 0): DirectionalButton.up,
              Point(2, 0): DirectionalButton.activate,
              Point(0, 1): DirectionalButton.left,
              Point(1, 1): DirectionalButton.down,
              Point(2, 1): DirectionalButton.right,
            },
          ),
        // Start out pointing at the A button.
        Point(2, 0));
  }

  Point<int> buttonLocation(DirectionalButton button) =>
      layout.inverse[button]!;

  /// Returns all of the combinations of steps from
  Iterable<List<DirectionalButton>> stepCombinationsTo(
          Point<int> starting, DirectionalButton target) =>
      generateStepCombinationsTo(starting, layout.inverse[target]!, layout,
          (button) => button != DirectionalButton.none);
}

/// Returns all of the combinations of steps from
List<List<DirectionalButton>> generateStepCombinationsTo<T>(Point<int> starting,
    Point<int> target, BiMap<Point<int>, T> map, bool Function(T) isValid) {
  // Store a list of paths. Each path needs to keep track of its current
  // location, and list of directions so far.
  List<(Point<int>, List<DirectionalButton>)> paths = [];
  paths.add((starting, []));

  while (paths.none((p) => p.$1 == target)) {
    List<(Point<int>, List<DirectionalButton>)> newPaths = [];
    // Increment each path by one space.
    for (final path in paths) {
      for (final step in DirectionalButton.directions) {
        final newLocation = path.$1 + step.step;
        final buttonAtLocation = map[newLocation];

        // Only allow moves that remain within the keypad, are not over
        // empty spaces ('X'), and move the pointer closer to the target.
        if (buttonAtLocation != null &&
            isValid(buttonAtLocation) &&
            path.$1.squaredDistanceTo(target) >
                newLocation.squaredDistanceTo(target)) {
          newPaths.add((path.$1 + step.step, [...path.$2, step.direction]));
        }
      }
    }

    paths = newPaths;
  }

  return paths
      .where((p) => p.$1 == target)
      .map((p) => p.$2)
      .map((p) => p..add(DirectionalButton.activate))
      .toList();
}

int shortestSequence(String code) {
  final numericKeypad = NumericKeypad.standard();
  final directionalKeypad = DirectionalKeypad.standard();

  List<List<DirectionalButton>> numericSteps = [];

  // Find how to move in the numeric keypad
  Point<int> numericKeypadPointer = numericKeypad.location;
  for (final char in code.split('')) {
    List<List<DirectionalButton>> newList = [];
    final numericStepsForChar =
        numericKeypad.stepCombinationsTo(numericKeypadPointer, char);
    if (numericSteps.isEmpty) {
      newList.addAll(numericStepsForChar);
    } else {
      for (final previousDirections in numericSteps) {
        for (final newDirections in numericStepsForChar) {
          newList.add([...previousDirections, ...newDirections]);
        }
      }
    }

    numericKeypadPointer = numericKeypad.buttonLocation(char);
    numericSteps = newList;
  }

  // Find moves in directional keypads 1 and 2 (robots 2 and 3).
  List<List<DirectionalButton>> allDirectionalSteps = [];
  List<List<DirectionalButton>> listToProcess = numericSteps;
  for (int i = 2; i <= 3; i++) {
    List<List<DirectionalButton>> directionalStepsI = [];
    for (final steps in listToProcess) {
      Point<int> directionalKeypadPointer = directionalKeypad.location;
      List<List<DirectionalButton>> allOptionsForThisNumericOptions = [];
      for (final step in steps) {
        final directionSteps = directionalKeypad.stepCombinationsTo(
            directionalKeypadPointer, step);
        List<List<DirectionalButton>> newList = [];

        if (allOptionsForThisNumericOptions.isEmpty) {
          newList.addAll(directionSteps);
        } else {
          for (final previousDirections in allOptionsForThisNumericOptions) {
            for (final newDirections in directionSteps) {
              newList.add([...previousDirections, ...newDirections]);
            }
          }
        }

        directionalKeypadPointer = directionalKeypad.buttonLocation(step);
        allOptionsForThisNumericOptions = newList;
      }

      directionalStepsI.addAll(allOptionsForThisNumericOptions);
    }

    allDirectionalSteps = directionalStepsI;
    listToProcess = directionalStepsI;
  }

  return allDirectionalSteps.map((s) => s.length).min;
}

String directionsToString(List<DirectionalButton> directions) {
  StringBuffer sb = StringBuffer();
  for (final direction in directions) {
    sb.write(direction.toString());
  }
  return sb.toString();
}

/// Loads the data for a maze from a file.
Future<List<String>> loadData(File file) async {
  final lines = await file.readAsLines();
  return lines;
}
