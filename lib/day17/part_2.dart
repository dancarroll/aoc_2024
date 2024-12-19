import 'dart:io';

import 'package:aoc_2024/lib.dart';

import 'shared.dart';

/// Continuing from Part 1, it was determined that the program is expected
/// to produce output that matches the program itself. The given value for
/// register A is corrupted. Determine the lowest value for register A, such
/// that the program outputs itself.
Future<int> calculate(File file) async {
  // Register A: 62769524
  // Register B: 0
  // Register C: 0

  // Program: 2,4,1,7,7,5,0,3,4,0,1,7,5,5,3,0

  // Program steps:
  // 1. bst: b = Operand % 8
  //     - Compound operand 4: register A
  // 2. bxl: b = b XOR operand
  //     - Literal operand 7
  // 3. cdv: c = a / 2^operand
  //     - Compound operator 5: register B
  // 4. adv: a = a / 2^operand
  //     - Compount operand 3: literal 3
  // 5. bxc: b = b XOR c
  //     - Operand not used
  // 6. bxl: b = b XOR operand
  //     - Literal operand 7
  // 7. output: output operand % 8
  //     - Compund operand 5: register B
  // 8. jnz: jump to operand
  //     - Literal operand 0

  if (file.path.contains('sample_data')) {
    return 0;
  }

  const expectedResult = '2,4,1,7,7,5,0,3,4,0,1,7,5,5,3,0';
  final expectedSplit = expectedResult.split(',');

  final originalComputer = await loadData(file);
  originalComputer.a += 99999999999999 + 42126250 + 100000000 + 10000000;

  findUpper(originalComputer, 99999999999999 + 42126250 + 100000000 + 10000000);
  return 0;

  int maxCommonDigits = 0;
  int maxCommonDigitsIndex = 0;
  for (int i = 0; i < 10000000; i++) {
    final computer = Computer.fromComputer(originalComputer);
    //final a = computer.a + i * 250;
    final a = computer.a + i;
    computer.a = a;

    final result = computer.execute();
    //print(result);
    if (result == expectedResult) {
      return a;
    }

    final resultSplit = result.split(',');
    int count = 0;
    while (expectedSplit[count] == resultSplit[count]) {
      count++;
    }
    if (count > 6) {
      //print('$count digits in common!');
    }
    if (count > maxCommonDigits) {
      maxCommonDigits = count;
      maxCommonDigitsIndex = i;
      print('$count digits in common!');
      print(
          'Target length ${expectedResult.length}, current length ${result.length}');
    }

    if (i % 1000 == 0) {
      // print(
      //     'Target length ${expectedResult.length}, current length ${result.length}');
      // print('  - $result');
    }
  }

  print('Max common $maxCommonDigits at $maxCommonDigitsIndex');

  return 0;
}

const expectedResult = '2,4,1,7,7,5,0,3,4,0,1,7,5,5,3,0';
final expectedSplit = expectedResult.split(',');

void binary(Computer originalComputer) {
  int i = maxInt ~/ 2;
  int searchSpace = maxInt - i;

  while (searchSpace > 100000000000) {
    final computer = Computer.fromComputer(originalComputer);
    computer.a = i;
    final result = computer.execute();
    final resultSplit = result.split(',');

    int count = 0;
    while (expectedSplit[count] == resultSplit[count]) {
      count++;
    }

    if (result.length > expectedResult.length) {}
  }
}

void findUpper(Computer originalComputer, int start) {
  int i = start + (maxInt - start) ~/ 2;
  int searchSpace = maxInt;

  while (searchSpace > 10) {
    final computer = Computer.fromComputer(originalComputer);
    computer.a = i;
    final result = computer.execute();
    final resultSplit = result.split(',');

    // int count = 0;
    // while (expectedSplit[count] == resultSplit[count]) {
    //   count++;
    // }

    final oldI = i;
    if (result.length > expectedResult.length) {
      i = i - ((start - i).abs() ~/ 2);
    } else if (result.length <= expectedResult.length) {
      i = i + ((maxInt - i) ~/ 2);
    }

    searchSpace = (i - oldI).abs();

    //if (i % 10000 == 0) {
    print('$i: current length ${result.length}');
    // print('  - $result');
    //}
  }

  print('i: $i');
}
