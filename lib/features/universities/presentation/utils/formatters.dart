const _skippedWords = {'of', 'the', 'at', 'and', 'for', 'de', '&'};

final _startsWithLetter = RegExp(r'^\p{L}', unicode: true);

String initialsFor(String name) {
  final words = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => !_skippedWords.contains(word.toLowerCase()))
      .where(_startsWithLetter.hasMatch);

  final initials = words.take(2).map((word) => word[0].toUpperCase()).join();
  return initials.isEmpty ? '?' : initials;
}

String formatThousands(int value) {
  final digits = value.abs().toString();
  final buffer = StringBuffer(value < 0 ? '-' : '');
  for (var i = 0; i < digits.length; i++) {
    final remaining = digits.length - i;
    if (i > 0 && remaining % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}
