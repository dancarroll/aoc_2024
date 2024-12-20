import 'dart:io';
import 'dart:math' as math;

final class Towels {
  final List<String> towels;
  final List<String> patterns;

  Towels(this.towels, this.patterns);
}

Future<Towels> loadData(File file) async {
  final lines = await file.readAsLines();
  final towels = lines[0].split(',').map((s) => s.trim()).toList();
  return Towels(towels, lines.sublist(2, lines.length));
}
