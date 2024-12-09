import 'dart:io';

import 'shared.dart';

Future<int> calculate(File file) async {
  final memory = await loadData(file);

  int nextFree = 0;
  while (memory[nextFree].id != null) {
    nextFree++;
  }

  int nextToMove = memory.length - 1;
  while (memory[nextToMove].id == null) {
    nextToMove--;
  }

  while (nextToMove > nextFree) {
    memory[nextFree].id = memory[nextToMove].id;
    memory[nextToMove].id = null;
    nextFree++;
    nextToMove--;

    while (nextFree < memory.length && memory[nextFree].id != null) {
      nextFree++;
    }
    while (nextToMove >= 0 && memory[nextToMove].id == null) {
      nextToMove--;
    }
  }

  int checksum = 0;
  for (int i = 0; i < memory.length; i++) {
    final memoryVal = memory[i].id ?? 0;
    checksum += memoryVal * i;
  }
  return checksum;
}
