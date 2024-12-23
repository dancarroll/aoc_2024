import 'dart:io';

import 'package:collection/collection.dart';

import 'shared.dart';

/// Represents an interconnected group of computers.
final class Group {
  final Set<String> computers;
  String? _cachedString;

  Group(String name, String connection) : computers = {} {
    computers.add(name);
    computers.add(connection);
  }

  Group.fromSet(this.computers);

  /// Returns true if the group contains the specified pair of computers.
  bool containsPair(String a, String b) =>
      computers.contains(a) && computers.contains(b);

  /// Add a new computer to this group.
  void add(String name) {
    computers.add(name);
    _cachedString = null;
  }

  @override
  bool operator ==(Object other) {
    if (other is Group) {
      return toString() == other.toString();
    }
    return false;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    _cachedString ??= computers.sorted().join(',');
    return _cachedString!;
  }
}

/// Continuing from part 1, rather than finding all groups of three computers,
/// find the largest interconnected group.
///
/// Return the sorted, comma-separated list of all computers in that group.
Future<String> calculate(File file) async {
  final network = await loadData(file);

  Set<Group> groups = {};
  for (final computer in network.entries) {
    final connections = computer.value;
    for (final connection in connections) {
      final existingGroups = groups
          .where((g) => g.containsPair(computer.key, connection))
          .toList();
      // If we haven't encountered this pair before, add a new group
      // and continue to the new pair.
      if (existingGroups.isEmpty) {
        final group = Group(computer.key, connection);
        groups.add(group);
        continue;
      }

      // For each group containing this pair, check which potential connections
      // are also interconnected with this group.
      for (final existingGroup in existingGroups) {
        var allPotentialConnections = existingGroup.computers
            .toList()
            .fold(<String>{}, (e, v) => e.union(network[v]!)).where(
                (c) => c != computer.key && c != connection);

        // For all potential connections, if they connect to every computer in
        // the group, create a new group with the existing members plus the
        // new connection.
        for (final potentialConnection in allPotentialConnections) {
          if (existingGroup.computers
              .every((c) => network[c]!.contains(potentialConnection))) {
            groups.add(Group.fromSet(
                {...existingGroup.computers, potentialConnection}));
          }
        }
      }
    }
  }

  return groups
      .sorted((g1, g2) => g2.computers.length.compareTo(g1.computers.length))
      .first
      .toString();
}
