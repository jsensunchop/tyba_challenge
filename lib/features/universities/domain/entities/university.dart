class University {
  const University({
    required this.id,
    required this.name,
    required this.country,
    required this.stateProvince,
    required this.domains,
    required this.webPages,
  });

  final int id;
  final String name;
  final String country;
  final String? stateProvince;
  final List<String> domains;
  final List<String> webPages;
}
