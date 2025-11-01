# Arabic Converters 🇸🇦

A comprehensive Flutter package for converting numbers between Arabic and English formats, and converting dates between Gregorian and Hijri calendars.

## Features ✨

- 🔢 Convert numbers between Arabic (٠١٢٣٤٥٦٧٨٩) and English (0123456789) digits
- 📅 Convert dates between Gregorian and Hijri calendars
- 🌙 Get current Hijri date
- 📝 Format dates in Arabic
- ✅ Check for Arabic or English digits in strings

## Installation 📦

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  arabic_converters: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage 🚀

### Number Conversion

```dart
import 'package:arabic_converters/arabic_converters.dart';

// Convert English to Arabic digits
String arabic = NumberConverter.toArabic('12345');
print(arabic); // ١٢٣٤٥

// Convert Arabic to English digits
String english = NumberConverter.toEnglish('١٢٣٤٥');
print(english); // 12345

// Convert integer to Arabic
String arabicNum = NumberConverter.intToArabic(2024);
print(arabicNum); // ٢٠٢٤

// Convert Arabic string to integer
int number = NumberConverter.arabicToInt('٢٠٢٤');
print(number); // 2024

// Check for Arabic digits
bool hasArabic = NumberConverter.hasArabicDigits('١٢٣');
print(hasArabic); // true

// Check for English digits
bool hasEnglish = NumberConverter.hasEnglishDigits('123');
print(hasEnglish); // true
```

### Date Conversion

```dart
import 'package:arabic_converters/arabic_converters.dart';

// Convert Gregorian to Hijri
DateTime gregorian = DateTime(2024, 3, 11);
HijriDate hijri = DateConverter.toHijri(gregorian);
print(hijri.toArabicFormat()); // ١ رمضان ١٤٤٥
print(hijri.toEnglishFormat()); // 1 Ramadan 1445
print(hijri.toNumericFormat()); // 01/09/1445

// Convert Hijri to Gregorian
HijriDate hijriDate = HijriDate(year: 1445, month: 9, day: 1);
DateTime gregorianDate = DateConverter.toGregorian(hijriDate);
print(gregorianDate); // 2024-03-11

// Get current Hijri date
HijriDate today = DateConverter.getCurrentHijriDate();
print(today.toArabicFormat());

// Format date in Arabic
String arabicDate = DateConverter.formatArabicDate(DateTime.now());
print(arabicDate); // الجمعة، ١ نوفمبر ٢٠٢٤

// Get month name
print(hijri.monthName); // رمضان
print(hijri.monthNameEnglish); // Ramadan
```

## API Reference 📚

### NumberConverter

- `String toArabic(String input)` - Converts English digits to Arabic
- `String toEnglish(String input)` - Converts Arabic digits to English
- `String intToArabic(int number)` - Converts integer to Arabic digit string
- `int arabicToInt(String arabicNumber)` - Converts Arabic digit string to integer
- `bool hasArabicDigits(String input)` - Checks if string contains Arabic digits
- `bool hasEnglishDigits(String input)` - Checks if string contains English digits

### DateConverter

- `HijriDate toHijri(DateTime gregorianDate)` - Converts Gregorian to Hijri date
- `DateTime toGregorian(HijriDate hijriDate)` - Converts Hijri to Gregorian date
- `HijriDate getCurrentHijriDate()` - Gets current date in Hijri calendar
- `String formatArabicDate(DateTime date)` - Formats date in Arabic

### HijriDate

Properties:
- `int year` - Hijri year
- `int month` - Hijri month (1-12)
- `int day` - Day of month
- `String monthName` - Arabic month name
- `String monthNameEnglish` - English month name

Methods:
- `String toArabicFormat()` - Format as "١٥ رمضان ١٤٤٦"
- `String toEnglishFormat()` - Format as "15 Ramadan 1446"
- `String toNumericFormat()` - Format as "DD/MM/YYYY"

## Example App 📱

Check out the [example](example) directory for a complete sample application demonstrating all features.

## Hijri Calendar Notes 📝

The Hijri calendar conversion uses astronomical calculations. Please note:
- The Hijri calendar is lunar-based with 354 or 355 days per year
- Actual moon sighting may vary by 1-2 days from calculated dates
- Different Islamic authorities may observe different dates

## Contributing 🤝

Contributions are welcome! Please feel free to submit a Pull Request.

## License 📄

This project is licensed under the MIT License - see the LICENSE file for details.

## Author ✍️

Created with ❤️ by Ahmed Algzery

## Support 💬

For issues, questions, or suggestions, please file an issue on the [GitHub repository](https://github.com/ahmed-algzery//arabic_converters).# arabic_converters
