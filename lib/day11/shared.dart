import 'dart:io';

///
Future<List<int>> loadData(File file) async {
  final lines = await file.readAsString();

  return lines.split(' ').map(int.parse).toList();
}
