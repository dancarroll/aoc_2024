import 'dart:io';
import 'dart:math' as math;

import 'shared.dart';

const int numBlinks = 75;

final dict = <int, int>{};

int numDigits(final int num) => switch (num) {
      < 10 => 1,
      < 100 => 2,
      < 1000 => 3,
      < 10000 => 4,
      < 100000 => 5,
      < 1000000 => 6,
      < 10000000 => 7,
      < 100000000 => 8,
      < 1000000000 => 9,
      < 10000000000 => 10,
      < 100000000000 => 11,
      < 1000000000000 => 12,
      < 10000000000000 => 13,
      < 100000000000000 => 14,
      < 1000000000000000 => 15,
      _ => throw Exception('num $num too large')
    };

// Store calculation of a given value/blink pair. If we've already processed
// a given stone at the blink number, then we should know what value it would
// end at.
final savedCalculations = <(int, int), int>{};

Future<int> calculate(File file) async {
  final originalStones = await loadData(file);

  int numStones = 0;
  for (final stone in originalStones) {
    numStones += _calculate(stone, 0);
  }

  return numStones;
}

int _calculate(int stone, int blink) {
  if (blink == numBlinks) {
    //savedCalculations[(stone, blink)] = 1;
    return 1;
  }

  final prev = savedCalculations[(stone, blink)];
  if (prev != null) {
    return prev;
  }

  final digits = numDigits(stone);
  late int val;
  if (stone == 0) {
    val = _calculate(1, blink + 1);
  } else if (digits.isEven) {
    final midpoint = digits ~/ 2;

    final pow = math.pow(10, midpoint);
    final stoneLeft = stone ~/ pow;
    final stoneRight = stone - (stoneLeft * pow).toInt();

    val = _calculate(stoneLeft, blink + 1) + _calculate(stoneRight, blink + 1);
  } else {
    val = _calculate(stone * 2024, blink + 1);
  }

  savedCalculations[(stone, blink)] = val;
  return val;
}
