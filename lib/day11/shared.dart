import 'dart:io';
import 'dart:math' as math;

import 'package:collection/collection.dart';

///
Future<List<int>> loadData(File file) async {
  final lines = await file.readAsString();

  return lines.split(' ').map(int.parse).toList();
}
