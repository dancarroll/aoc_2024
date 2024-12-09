import 'dart:io';

import 'shared.dart';

Future<int> calculate(File file) async {
  final references = await loadDiskMap(file);

  int nextFree = 1;

  int nextToMove = references.length - 1;
  // while (references[nextToMove].id == null) {
  //   nextToMove--;
  // }

  while (nextToMove > nextFree && nextToMove >= 1) {
    //_printDiskMap(references);
    while (references[nextToMove].id == null) {
      nextToMove--;
    }
    while (nextFree < nextToMove &&
        (references[nextToMove].size > references[nextFree].size ||
            references[nextFree].id != null)) {
      nextFree++;
    }

    if (nextFree >= nextToMove) {
      nextToMove--;
      nextFree = 0;
      continue;
    }

    // print('Identified swap: moving memory');
    // print('  - from $nextToMove (size ${references[nextToMove].size})');
    // print('  - to $nextFree (size ${references[nextFree].size})');

    final remainingFreeSpace =
        references[nextFree].size - references[nextToMove].size;
    references[nextFree].size = references[nextToMove].size;
    references[nextFree].id = references[nextToMove].id;
    references[nextToMove].id = null;

    if (remainingFreeSpace > 0) {
      references.insert(
          nextFree + 1, DiskReference(size: remainingFreeSpace, id: null));
    } else {
      nextToMove--;
    }

    nextFree = 0;
  }

  //_printDiskMap(references);

  final memory = convertDiskMap(references);
  int checksum = 0;
  for (int i = 0; i < memory.length; i++) {
    final memoryVal = memory[i].id ?? 0;
    checksum += memoryVal * i;
  }
  return checksum;
}

void _printDiskMap(List<DiskReference> references) {
  var map = '';
  for (final ref in references) {
    map += ref.size.toString();
  }
  print('Disk map: $map');

  var memory = '';
  for (final ref in references) {
    for (int i = 0; i < ref.size; i++) {
      memory += ref.id?.toString() ?? '.';
    }
  }
  print('Memory: $memory');
}
