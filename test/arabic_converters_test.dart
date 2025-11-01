import 'package:flutter_test/flutter_test.dart';
import 'package:arabic_converters/arabic_converters.dart';

void main() {
  group('NumberConverter Tests', () {
    test('Convert English to Arabic digits', () {
      expect(NumberConverter.toArabic('0'), '٠');
      expect(NumberConverter.toArabic('123'), '١٢٣');
      expect(NumberConverter.toArabic('456789'), '٤٥٦٧٨٩');
      expect(NumberConverter.toArabic('2024'), '٢٠٢٤');
    });

    test('Convert Arabic to English digits', () {
      expect(NumberConverter.toEnglish('٠'), '0');
      expect(NumberConverter.toEnglish('١٢٣'), '123');
      expect(NumberConverter.toEnglish('٤٥٦٧٨٩'), '456789');
      expect(NumberConverter.toEnglish('٢٠٢٤'), '2024');
    });

    test('Convert integer to Arabic', () {
      expect(NumberConverter.intToArabic(0), '٠');
      expect(NumberConverter.intToArabic(123), '١٢٣');
      expect(NumberConverter.intToArabic(2024), '٢٠٢٤');
    });

    test('Convert Arabic string to integer', () {
      expect(NumberConverter.arabicToInt('٠'), 0);
      expect(NumberConverter.arabicToInt('١٢٣'), 123);
      expect(NumberConverter.arabicToInt('٢٠٢٤'), 2024);
    });

    test('Detect Arabic digits', () {
      expect(NumberConverter.hasArabicDigits('١٢٣'), true);
      expect(NumberConverter.hasArabicDigits('123'), false);
      expect(NumberConverter.hasArabicDigits('١٢٣abc'), true);
      expect(NumberConverter.hasArabicDigits('abc'), false);
    });

    test('Detect English digits', () {
      expect(NumberConverter.hasEnglishDigits('123'), true);
      expect(NumberConverter.hasEnglishDigits('١٢٣'), false);
      expect(NumberConverter.hasEnglishDigits('123abc'), true);
      expect(NumberConverter.hasEnglishDigits('abc'), false);
    });

    test('Handle mixed text with digits', () {
      expect(NumberConverter.toArabic('Phone: 123-456'), 'Phone: ١٢٣-٤٥٦');
      expect(NumberConverter.toEnglish('الهاتف: ١٢٣-٤٥٦'), 'الهاتف: 123-456');
    });
  });

  group('DateConverter Tests', () {
    test('Convert specific Gregorian dates to Hijri', () {
      // Test multiple known conversions
      // Using dates from reliable Islamic calendar sources

      // January 1, 2024 = approximately 19 Jumada al-Akhirah 1445
      DateTime date1 = DateTime(2024, 1, 1);
      HijriDate hijri1 = DateConverter.toHijri(date1);
      expect(hijri1.year, 1445);
      expect(hijri1.month, 6); // Jumada al-Akhirah

      // March 11, 2024 = approximately 1 Ramadan 1445
      DateTime date2 = DateTime(2024, 3, 11);
      HijriDate hijri2 = DateConverter.toHijri(date2);
      expect(hijri2.year, 1445);
      expect(hijri2.month, 9); // Ramadan
      expect(hijri2.day, greaterThanOrEqualTo(1));
      expect(hijri2.day, lessThanOrEqualTo(3)); // Allow some tolerance
    });

    test('Convert Hijri dates to Gregorian', () {
      // Test conversion from Hijri to Gregorian
      HijriDate hijri = const HijriDate(year: 1445, month: 1, day: 1);
      DateTime gregorian = DateConverter.toGregorian(hijri);

      // 1 Muharram 1445 should be around July 2023
      expect(gregorian.year, 2023);
      expect(gregorian.month, inInclusiveRange(7, 8));
    });

    test('Round-trip conversion consistency', () {
      // Test that converting back and forth gives consistent results
      DateTime original = DateTime(2024, 1, 15);
      HijriDate hijri = DateConverter.toHijri(original);
      DateTime converted = DateConverter.toGregorian(hijri);

      // Should be the same date
      expect(converted.year, original.year);
      expect(converted.month, original.month);
      expect(converted.day, original.day);
    });

    test('Test multiple round-trip conversions', () {
      // Test several dates to ensure consistency
      List<DateTime> testDates = [
        DateTime(2020, 1, 1),
        DateTime(2021, 6, 15),
        DateTime(2022, 12, 31),
        DateTime(2023, 5, 10),
        DateTime(2024, 3, 11),
      ];

      for (DateTime original in testDates) {
        HijriDate hijri = DateConverter.toHijri(original);
        DateTime converted = DateConverter.toGregorian(hijri);

        expect(converted.year, original.year,
            reason: 'Year mismatch for ${original.toString()}');
        expect(converted.month, original.month,
            reason: 'Month mismatch for ${original.toString()}');
        expect(converted.day, original.day,
            reason: 'Day mismatch for ${original.toString()}');
      }
    });

    test('Get current Hijri date', () {
      HijriDate today = DateConverter.getCurrentHijriDate();

      expect(today.year, greaterThan(1440));
      expect(today.month, greaterThanOrEqualTo(1));
      expect(today.month, lessThanOrEqualTo(12));
      expect(today.day, greaterThanOrEqualTo(1));
      expect(today.day, lessThanOrEqualTo(30));
    });

    test('Format Arabic date', () {
      DateTime date = DateTime(2024, 11, 1); // Friday
      String formatted = DateConverter.formatArabicDate(date);

      expect(formatted, contains('نوفمبر'));
      expect(formatted, contains('٢٠٢٤'));
    });

    test('Get Hijri year days', () {
      // Test leap and non-leap years
      int normalYearDays = DateConverter.getHijriYearDays(1444);
      int leapYearDays = DateConverter.getHijriYearDays(1445);

      expect([354, 355], contains(normalYearDays));
      expect([354, 355], contains(leapYearDays));
    });
  });

  group('HijriDate Tests', () {
    test('Create HijriDate', () {
      HijriDate date = const HijriDate(year: 1445, month: 9, day: 15);

      expect(date.year, 1445);
      expect(date.month, 9);
      expect(date.day, 15);
    });

    test('Get month names', () {
      HijriDate date = const HijriDate(year: 1445, month: 9, day: 1);

      expect(date.monthName, 'رمضان');
      expect(date.monthNameEnglish, 'Ramadan');
    });

    test('Format dates', () {
      HijriDate date = const HijriDate(year: 1445, month: 9, day: 15);

      expect(date.toArabicFormat(), '15 رمضان 1445');
      expect(date.toEnglishFormat(), '15 Ramadan 1445');
      expect(date.toNumericFormat(), '15/09/1445');
    });

    test('HijriDate equality', () {
      HijriDate date1 = const HijriDate(year: 1445, month: 9, day: 15);
      HijriDate date2 = const HijriDate(year: 1445, month: 9, day: 15);
      HijriDate date3 = const HijriDate(year: 1445, month: 9, day: 16);

      expect(date1 == date2, true);
      expect(date1 == date3, false);
      expect(date1.hashCode == date2.hashCode, true);
    });

    test('All month names are available', () {
      for (int i = 1; i <= 12; i++) {
        HijriDate date = HijriDate(year: 1445, month: i, day: 1);
        expect(date.monthName.isNotEmpty, true);
        expect(date.monthNameEnglish.isNotEmpty, true);
      }
    });
  });

  group('Edge Cases', () {
    test('Handle empty strings in number conversion', () {
      expect(NumberConverter.toArabic(''), '');
      expect(NumberConverter.toEnglish(''), '');
    });

    test('Handle strings without digits', () {
      expect(NumberConverter.toArabic('hello'), 'hello');
      expect(NumberConverter.toEnglish('مرحبا'), 'مرحبا');
    });

    test('Handle leap years in Hijri calendar', () {
      // Test conversion for dates at the end of leap years
      for (int year = 1440; year < 1450; year++) {
        HijriDate endOfYear = HijriDate(year: year, month: 12, day: 29);
        DateTime gregorian = DateConverter.toGregorian(endOfYear);
        expect(gregorian.year, greaterThan(2018));

        // Convert back and verify
        HijriDate converted = DateConverter.toHijri(gregorian);
        expect(converted.year, year);
        expect(converted.month, 12);
        expect(converted.day, 29);
      }
    });

    test('Handle very old dates', () {
      DateTime old = DateTime(1900, 1, 1);
      HijriDate oldHijri = DateConverter.toHijri(old);
      expect(oldHijri.year, greaterThan(1300));
      expect(oldHijri.year, lessThan(1400));

      // Verify round-trip
      DateTime converted = DateConverter.toGregorian(oldHijri);
      expect(converted.year, old.year);
      expect(converted.month, old.month);
      expect(converted.day, old.day);
    });

    test('Handle future dates', () {
      DateTime future = DateTime(2050, 12, 31);
      HijriDate futureHijri = DateConverter.toHijri(future);
      expect(futureHijri.year, greaterThan(1470));

      // Verify round-trip
      DateTime converted = DateConverter.toGregorian(futureHijri);
      expect(converted.year, future.year);
      expect(converted.month, future.month);
      expect(converted.day, future.day);
    });

    test('Test first day of each Hijri month', () {
      for (int month = 1; month <= 12; month++) {
        HijriDate hijri = HijriDate(year: 1445, month: month, day: 1);
        DateTime gregorian = DateConverter.toGregorian(hijri);
        HijriDate converted = DateConverter.toHijri(gregorian);

        expect(converted.year, hijri.year);
        expect(converted.month, hijri.month);
        expect(converted.day, hijri.day);
      }
    });
  });
}
