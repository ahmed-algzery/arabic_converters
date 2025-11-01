/// A utility class for converting numbers between Arabic and English formats.
class NumberConverter {
  // Arabic digits: ٠١٢٣٤٥٦٧٨٩
  static const Map<String, String> _arabicToEnglish = {
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
  };

  static const Map<String, String> _englishToArabic = {
    '0': '٠',
    '1': '١',
    '2': '٢',
    '3': '٣',
    '4': '٤',
    '5': '٥',
    '6': '٦',
    '7': '٧',
    '8': '٨',
    '9': '٩',
  };

  /// Converts Arabic digits to English digits
  ///
  /// Example:
  /// ```dart
  /// String result = NumberConverter.toEnglish('١٢٣٤٥'); // '12345'
  /// ```
  static String toEnglish(String input) {
    String result = input;
    _arabicToEnglish.forEach((arabic, english) {
      result = result.replaceAll(arabic, english);
    });
    return result;
  }

  /// Converts English digits to Arabic digits
  ///
  /// Example:
  /// ```dart
  /// String result = NumberConverter.toArabic('12345'); // '١٢٣٤٥'
  /// ```
  static String toArabic(String input) {
    String result = input;
    _englishToArabic.forEach((english, arabic) {
      result = result.replaceAll(english, arabic);
    });
    return result;
  }

  /// Checks if a string contains Arabic digits
  static bool hasArabicDigits(String input) {
    return _arabicToEnglish.keys.any((digit) => input.contains(digit));
  }

  /// Checks if a string contains English digits
  static bool hasEnglishDigits(String input) {
    return _englishToArabic.keys.any((digit) => input.contains(digit));
  }

  /// Converts an integer to Arabic digit string
  ///
  /// Example:
  /// ```dart
  /// String result = NumberConverter.intToArabic(12345); // '١٢٣٤٥'
  /// ```
  static String intToArabic(int number) {
    return toArabic(number.toString());
  }

  /// Converts an Arabic digit string to integer
  ///
  /// Example:
  /// ```dart
  /// int result = NumberConverter.arabicToInt('١٢٣٤٥'); // 12345
  /// ```
  static int arabicToInt(String arabicNumber) {
    return int.parse(toEnglish(arabicNumber));
  }
}
