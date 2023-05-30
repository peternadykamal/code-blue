String compareStrings(String inputString, String targetString) {
  List<String> inputWords = inputString.split(' ');
  List<String> targetWords = targetString.split(' ');

  List<String> differingWords = [];

  for (String word in inputWords) {
    if (!targetWords.contains(word)) {
      differingWords.add(word);
    }
  }

  return differingWords.join(' ');
}
