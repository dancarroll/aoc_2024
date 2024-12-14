import 'dart:io';

import 'shared.dart';

/// Continuing from Part 1, it is expected that these robots have an
/// easter egg when there should arrange themselves into a picture of
/// a Christmas tree.
///
/// Return the fewest number of seconds for the robots to demonstrate
/// this easter egg.
Future<int> calculate(File file) async {
  final data = await loadData(file);

  return data.height;
}
