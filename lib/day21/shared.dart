import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart' as collection;
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
  Iterable<DirectionList> stepCombinationsTo(Point<int> starting, String char,
          {required bool useNewSequenceGenerator}) =>
      generateStepCombinationsTo(
          starting, layout.inverse[char]!, layout, (c) => c != 'X',
          useNewSequenceGenerator: useNewSequenceGenerator);
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
  Set<DirectionList> stepCombinationsTo(
          Point<int> starting, DirectionalButton target,
          {required bool useNewSequenceGenerator}) =>
      generateStepCombinationsTo(starting, layout.inverse[target]!, layout,
          (button) => button != DirectionalButton.none,
          useNewSequenceGenerator: useNewSequenceGenerator);
}

final class DirectionList extends collection.DelegatingList<DirectionalButton> {
  DirectionList(super.base);

  List<DirectionalButton> get _listBase => super.toList();

  @override
  bool operator ==(Object other) {
    if (other is DirectionList) {
      return toString() == other.toString();
    }
    return false;
  }

  @override
  int get hashCode => Object.hashAll(this);

  @override
  String toString() => directionsToString(_listBase);
}

/// Returns all of the combinations of steps from
Set<DirectionList> generateStepCombinationsTo<T>(Point<int> starting,
    Point<int> target, BiMap<Point<int>, T> map, bool Function(T) isValid,
    {required bool useNewSequenceGenerator}) {
  if (useNewSequenceGenerator) {
    final diff = target - starting;
    final xMoves = List.generate(diff.x.abs(),
        (_) => (diff.x < 0) ? DirectionalButton.left : DirectionalButton.right);
    final yMoves = List.generate(diff.y.abs(),
        (_) => (diff.y < 0) ? DirectionalButton.up : DirectionalButton.down);

    final type = map[target]!;

    var skipXMoveFirst = false;
    if (type is String && starting.y == 3 && diff.x < 0) {
      skipXMoveFirst = true;
    } else if (type is DirectionalButton && starting.y == 0 && diff.x < 0) {
      skipXMoveFirst = true;
    }

    var skipYMoveFirst = false;
    if (type is String && starting.x == 0 && diff.y > 0) {
      skipYMoveFirst = true;
    } else if (type is DirectionalButton && starting.x == 0 && diff.y < 0) {
      skipYMoveFirst = true;
    }

    late Set<DirectionList> alternateList;
    if (diff.x < 0 && !skipXMoveFirst) {
      alternateList = {
        skipXMoveFirst
            ? DirectionList([])
            : DirectionList([...xMoves, ...yMoves, DirectionalButton.activate]),
      };
    } else {
      alternateList = {
        skipXMoveFirst
            ? DirectionList([])
            : DirectionList([...xMoves, ...yMoves, DirectionalButton.activate]),
        skipYMoveFirst
            ? DirectionList([])
            : DirectionList([...yMoves, ...xMoves, DirectionalButton.activate]),
      };
    }

    // final alternateList = {
    //   skipXMoveFirst
    //       ? DirectionList([])
    //       : DirectionList([...xMoves, ...yMoves, DirectionalButton.activate]),
    //   skipYMoveFirst
    //       ? DirectionList([])
    //       : DirectionList([...yMoves, ...xMoves, DirectionalButton.activate]),
    // };

    // printDirectionLists(
    //     'Correct', paths.where((p) => p.$1 == target).map((p) => p.$2).toList());
    // printDirectionLists('Simplified',
    //     paths.where((p) => p.$1 == target).map((p) => p.$2).toList());

    return alternateList..removeWhere((l) => l.isEmpty);
  }

  // Store a list of paths. Each path needs to keep track of its current
  // location, and list of directions so far.
  List<(Point<int>, DirectionList)> paths = [];
  paths.add((starting, DirectionList([])));

  while (paths.none((p) => p.$1 == target)) {
    List<(Point<int>, DirectionList)> newPaths = [];
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
          newPaths.add((
            path.$1 + step.step,
            DirectionList([...path.$2, step.direction])
          ));
        }
      }
    }

    paths = newPaths;
  }

  return paths
      .where((p) => p.$1 == target)
      .map((p) => p.$2)
      .map((p) => p..add(DirectionalButton.activate))
      .toSet();
}

int shortestSequence(String code, int numDirectionalKeypads,
    {bool useNewSequenceGenerator = false}) {
  final numericKeypad = NumericKeypad.standard();
  final directionalKeypad = DirectionalKeypad.standard();

  Set<DirectionList> numericSteps = {};

  // Find how to move in the numeric keypad
  Point<int> numericKeypadPointer = numericKeypad.location;
  for (final char in code.split('')) {
    Set<DirectionList> newList = {};
    final numericStepsForChar = numericKeypad.stepCombinationsTo(
        numericKeypadPointer, char,
        useNewSequenceGenerator: useNewSequenceGenerator);
    if (numericSteps.isEmpty) {
      newList.addAll(numericStepsForChar);
    } else {
      for (final previousDirections in numericSteps) {
        for (final newDirections in numericStepsForChar) {
          newList.add(DirectionList([...previousDirections, ...newDirections]));
        }
      }
    }

    numericKeypadPointer = numericKeypad.buttonLocation(char);
    numericSteps = newList;
  }

  printDirectionLists('Code $code', numericSteps);

  // Find moves in directional keypads 1 and 2 (robots 2 and 3).
  Set<DirectionList> allDirectionalSteps = {};
  Set<DirectionList> listToProcess = numericSteps;
  for (int i = 0; i < numDirectionalKeypads; i++) {
    print('Step $i: ${allDirectionalSteps.length}');
    //print('Directional Keypad $i');
    Set<DirectionList> directionalStepsI = {};
    for (final steps in listToProcess) {
      Point<int> directionalKeypadPointer = directionalKeypad.location;
      Set<DirectionList> allOptionsForThisNumericOptions = {};
      for (final step in steps) {
        final directionSteps = directionalKeypad.stepCombinationsTo(
            directionalKeypadPointer, step,
            useNewSequenceGenerator: useNewSequenceGenerator);
        Set<DirectionList> newList = {};

        if (allOptionsForThisNumericOptions.isEmpty) {
          newList.addAll(directionSteps);
        } else {
          for (final previousDirections in allOptionsForThisNumericOptions) {
            for (final newDirections in directionSteps) {
              newList.add(
                  DirectionList([...previousDirections, ...newDirections]));
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

  print('');
  //printDirectionLists('Final for $code', allDirectionalSteps);
  print('Final count for $code: ${allDirectionalSteps.length}');

  final ids = <String>{};
  allDirectionalSteps.retainWhere((x) => ids.add(directionsToString(x)));
  print('After removing dupes: ${allDirectionalSteps.length}');
  print('');

  return allDirectionalSteps.map((s) => s.length).min;
}

void printDirectionLists(
    String desc, Iterable<List<DirectionalButton>> directionLists) {
  print('$desc:');
  for (final list in directionLists) {
    print('  - ${directionsToString(list)}');
  }
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
