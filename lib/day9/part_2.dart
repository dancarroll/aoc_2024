import 'dart:io';

import 'shared.dart';

Future<int> calculate(File file) async {
  final references = await loadDiskMap(file);

  int nextFree = 1;
  int nextToMove = references.length - 1;

  while (nextToMove > nextFree && nextToMove >= 1) {
    while (references[nextToMove].isFree) {
      nextToMove--;
    }
    while (nextFree < nextToMove &&
        (references[nextToMove].size > references[nextFree].size ||
            !references[nextFree].isFree)) {
      nextFree++;
    }

    // If we've gotten into an illegal situation (moving memory to a
    // later position), then we can't move this block, so move to the
    // block on the left.
    if (nextFree >= nextToMove) {
      nextToMove--;
      nextFree = 0;
      continue;
    }

    final remainingFreeSpace =
        references[nextFree].size - references[nextToMove].size;
    references[nextFree].size = references[nextToMove].size;
    references[nextFree].id = references[nextToMove].id;
    references[nextToMove].id = null;

    if (remainingFreeSpace > 0) {
      references.insert(
          nextFree + 1, DiskReference(size: remainingFreeSpace, id: null));
    } else {
      // If we added a new disk reference, then don't decrement here,
      // otherwise we would be skipping a block (due to the indices changing).
      nextToMove--;
    }

    nextFree = 0;
  }

  final memory = convertDiskMap(references);
  int checksum = 0;
  for (int i = 0; i < memory.length; i++) {
    final memoryVal = memory[i].id ?? 0;
    checksum += memoryVal * i;
  }
  return checksum;
}
