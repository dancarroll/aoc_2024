import 'dart:io';

import 'package:aoc_2024/lib.dart';

final class DiskReference {
  int size;
  int? id;

  DiskReference({required this.size, required this.id});
}

final class MemoryLocation {
  int? id;

  MemoryLocation(this.id);
}

List<MemoryLocation> convertDiskMap(List<DiskReference> references) {
  List<MemoryLocation> memory = [];
  for (final ref in references) {
    for (int i = 0; i < ref.size; i++) {
      memory.add(MemoryLocation(ref.id));
    }
  }

  return memory;
}

Future<List<DiskReference>> loadDiskMap(File file) async {
  final line = await file.readAsString();

  List<DiskReference> references = [];
  int id = 0;
  bool isFile = true;
  for (int i = 0; i < line.length; i++) {
    references
        .add(DiskReference(size: int.parse(line[i]), id: isFile ? id : null));
    if (isFile) id++;
    isFile = !isFile;
  }

  return references;
}

Future<List<MemoryLocation>> loadMemory(File file) async {
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
