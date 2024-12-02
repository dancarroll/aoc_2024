import 'package:aoc_2024/lib.dart';

final class Contents {
  final List<int> listA;
  final List<int> listB;

  Contents(this.listA, this.listB);
}

Future<Contents> loadData(Resources resources) async {
  final file = resources.file(Day.day1);
  final lines = await file.readAsLines();

  final List<int> listA = [];
  final List<int> listB = [];

  for (final line in lines) {
    final values = line.split('   ');
    listA.add(int.parse(values[0]));
    listB.add(int.parse(values[1]));
  }
  listA.sort();
  listB.sort();

  return Contents(listA, listB);
}
