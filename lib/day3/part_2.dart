import 'package:aoc_2024/lib.dart';

import 'shared.dart';

Future<int> calculate(Resources resources) async {
  final data = await loadData(resources);

  var value = 0;
  var ignore = false;
  for (final instruction in data) {
    switch (instruction.runtimeType) {
      case == Do:
        ignore = false;
      case == Dont:
        ignore = true;
      case == Mult:
        if (!ignore) {
          value += (instruction as Mult).product;
        }
    }
  }
  return value;
}
