import 'dart:io';

import 'shared.dart';

/// Part 1 is 25 blinks.
const int numBlinks = 25;

Future<int> calculate(File file) async {
  final stones = await loadData(file);

  for (int i = 0; i < numBlinks; i++) {
    final numStones = stones.length;
    for (int j = 0; j < numStones; j++) {
      final stone = stones[j];
      if (stone == 0) {
        stones[j] = 1;
      } else if (stone.toString().length.isEven) {
        final str = stone.toString();
        final midpoint = str.length ~/ 2;
        final stoneLeft = int.parse(str.substring(0, midpoint));
        final stoneRight = int.parse(str.substring(midpoint));

        stones[j] = stoneLeft;
        stones.add(stoneRight);
      } else {
        stones[j] = stone * 2024;
      }
    }
  }

  return stones.length;
}
