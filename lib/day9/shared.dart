import 'dart:io';

import 'package:aoc_2024/lib.dart';

final class MemoryLocation {
  int? id;

  MemoryLocation(this.id);
}

/// Loads data from file, which is a map of frequency to
/// locations (points on a map).
Future<List<MemoryLocation>> loadData(File file) async {
  final line = await file.readAsString();

  List<MemoryLocation> memory = [];
  int id = 0;
  bool isFile = true;
  for (int i = 0; i < line.length; i++) {
    final count = int.parse(line[i]);
    for (int j = 0; j < count; j++) {
      memory.add(MemoryLocation(isFile ? id : null));
    }
    if (isFile) id++;
    isFile = !isFile;
  }

  return memory;
}
