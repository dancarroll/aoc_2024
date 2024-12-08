List<(T, T)> pairs<T>(List<T> items) {
  List<(T, T)> records = [];
  for (int i = 0; i < items.length - 1; i++) {
    for (int j = i + 1; j < items.length; j++) {
      records.add((items[i], items[j]));
    }
  }
  return records;
}
