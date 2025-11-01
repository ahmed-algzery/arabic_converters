import 'models/hijri_date.dart';

/// A utility class for converting dates between Gregorian and Hijri calendars.
class DateConverter {
  // Base date for conversion: July 19, 622 CE (Gregorian) = 1 Muharram 1 AH (Hijri)
  static final DateTime _hijriEpoch = DateTime.utc(622, 7, 19);

  // Days in each Hijri month for normal year
  static const List<int> _normalMonthDays = [
    30,
    29,
    30,
    29,
    30,
    29,
    30,
    29,
    30,
    29,
    30,
    29
  ];

  /// Converts a Gregorian date to Hijri date
  ///
  /// Example:
  /// ```dart
  /// HijriDate hijri = DateConverter.toHijri(DateTime(2024, 3, 11));
  /// print(hijri.toArabicFormat()); // ١ رمضان ١٤٤٥
  /// ```
  static HijriDate toHijri(DateTime gregorianDate) {
    // Normalize to UTC
    final date = DateTime.utc(
      gregorianDate.year,
      gregorianDate.month,
      gregorianDate.day,
    );

    // Calculate days since Hijri epoch
    int daysSinceEpoch = date.difference(_hijriEpoch).inDays;

    if (daysSinceEpoch < 0) {
      throw ArgumentError('Date must be after Hijri epoch (July 19, 622 CE)');
    }

    // Estimate Hijri year (average Hijri year is 354.36667 days)
    int hijriYear = ((daysSinceEpoch * 30) / 10631).floor() + 1;

    // Calculate the exact start of the estimated Hijri year
    int daysToStartOfYear = _daysFromEpochToYear(hijriYear);

    // Adjust if we overshot
    while (daysToStartOfYear > daysSinceEpoch) {
      hijriYear--;
      daysToStartOfYear = _daysFromEpochToYear(hijriYear);
    }

    // Make sure we have the right year
    while (daysToStartOfYear + (_isLeapYear(hijriYear) ? 355 : 354) <=
        daysSinceEpoch) {
      daysToStartOfYear += _isLeapYear(hijriYear) ? 355 : 354;
      hijriYear++;
    }

    // Calculate days into the year
    int daysIntoYear = daysSinceEpoch - daysToStartOfYear;

    // Find month and day
    int month = 1;
    int day = daysIntoYear + 1;

    for (int m = 1; m <= 12; m++) {
      int daysInMonth = _getMonthDays(hijriYear, m);
      if (day <= daysInMonth) {
        month = m;
        break;
      }
      day -= daysInMonth;
    }

    return HijriDate(year: hijriYear, month: month, day: day);
  }

  /// Converts a Hijri date to Gregorian date
  ///
  /// Example:
  /// ```dart
  /// DateTime gregorian = DateConverter.toGregorian(
  ///   HijriDate(year: 1445, month: 9, day: 1)
  /// );
  /// ```
  static DateTime toGregorian(HijriDate hijriDate) {
    // Calculate total days from epoch to the given Hijri date
    int totalDays = _daysFromEpochToYear(hijriDate.year);

    // Add days for complete months
    for (int m = 1; m < hijriDate.month; m++) {
      totalDays += _getMonthDays(hijriDate.year, m);
    }

    // Add the day
    totalDays += hijriDate.day - 1;

    // Add to epoch
    return _hijriEpoch.add(Duration(days: totalDays));
  }

  /// Calculate total days from Hijri epoch to the start of a given year
  static int _daysFromEpochToYear(int year) {
    int totalDays = 0;
    for (int y = 1; y < year; y++) {
      totalDays += _isLeapYear(y) ? 355 : 354;
    }
    return totalDays;
  }

  /// Gets the number of days in a specific Hijri month
  static int _getMonthDays(int year, int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError('Month must be between 1 and 12');
    }

    // Last month (Dhu al-Hijjah) has 30 days in leap years
    if (month == 12 && _isLeapYear(year)) {
      return 30;
    }

    return _normalMonthDays[month - 1];
  }

  /// Checks if a Hijri year is a leap year
  /// Uses the Kuwaiti algorithm (most accurate)
  /// In a 30-year cycle, years 2, 5, 7, 10, 13, 16, 18, 21, 24, 26, and 29 are leap years
  static bool _isLeapYear(int year) {
    return ((year * 11 + 14) % 30) < 11;
  }

  /// Gets the current date in Hijri calendar
  static HijriDate getCurrentHijriDate() {
    return toHijri(DateTime.now());
  }

  /// Gets the number of days in a Hijri year
  static int getHijriYearDays(int year) {
    return _isLeapYear(year) ? 355 : 354;
  }

  /// Formats a DateTime to Arabic date string
  ///
  /// Example:
  /// ```dart
  /// String formatted = DateConverter.formatArabicDate(DateTime.now());
  /// // الجمعة، ١ نوفمبر ٢٠٢٤
  /// ```
  static String formatArabicDate(DateTime date) {
    const List<String> arabicDays = [
      'الاثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ];

    const List<String> arabicMonths = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];

    String dayName = arabicDays[date.weekday - 1];
    String monthName = arabicMonths[date.month - 1];

    return '$dayName، ${_toArabicNumber(date.day)} $monthName ${_toArabicNumber(date.year)}';
  }

  /// Helper method to convert integer to Arabic digits
  static String _toArabicNumber(int number) {
    const Map<String, String> digits = {
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

    String result = number.toString();
    digits.forEach((english, arabic) {
      result = result.replaceAll(english, arabic);
    });
    return result;
  }
}
