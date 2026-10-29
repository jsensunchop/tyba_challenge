class University {
  const University({
    required this.id,
    required this.name,
    required this.country,
    required this.stateProvince,
    required this.domains,
    required this.webPages,
  });

  /// Position of the item in the source list. The API has no id, and neither
  /// `name` nor `domains` is unique, so the index is the only stable key.
  final int id;
  final String name;
  final String country;
  final String? stateProvince;
  final List<String> domains;
  final List<String> webPages;
}
