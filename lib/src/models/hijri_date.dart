/// Represents a Hijri (Islamic) date
class HijriDate {
  final int year;
  final int month;
  final int day;

  const HijriDate({
    required this.year,
    required this.month,
    required this.day,
  });

  /// Arabic month names
  static const List<String> monthNames = [
    'محرم',
    'صفر',
    'ربيع الأول',
    'ربيع الآخر',
    'جمادى الأولى',
    'جمادى الآخرة',
    'رجب',
    'شعبان',
    'رمضان',
    'شوال',
    'ذو القعدة',
    'ذو الحجة',
  ];

  /// English month names
  static const List<String> monthNamesEnglish = [
    'Muharram',
    'Safar',
    'Rabi\' al-Awwal',
    'Rabi\' al-Thani',
    'Jumada al-Ula',
    'Jumada al-Akhirah',
    'Rajab',
    'Sha\'ban',
    'Ramadan',
    'Shawwal',
    'Dhu al-Qi\'dah',
    'Dhu al-Hijjah',
  ];

  /// Gets the Arabic month name
  String get monthName => monthNames[month - 1];

  /// Gets the English month name
  String get monthNameEnglish => monthNamesEnglish[month - 1];

  /// Formats the date in Arabic format
  /// Example: ١٥ رمضان ١٤٤٦
  String toArabicFormat() {
    return '$day $monthName $year';
  }

  /// Formats the date in English format
  /// Example: 15 Ramadan 1446
  String toEnglishFormat() {
    return '$day $monthNameEnglish $year';
  }

  /// Formats the date as DD/MM/YYYY
  String toNumericFormat() {
    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
  }

  @override
  String toString() => toEnglishFormat();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HijriDate &&
          runtimeType == other.runtimeType &&
          year == other.year &&
          month == other.month &&
          day == other.day;

  @override
  int get hashCode => year.hashCode ^ month.hashCode ^ day.hashCode;
}
