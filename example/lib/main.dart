// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:arabic_converters/arabic_converters.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arabic Converters Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _numberController = TextEditingController();
  String _convertedNumber = '';
  DateTime _selectedDate = DateTime.now();
  HijriDate? _hijriDate;
  String _arabicFormattedDate = '';

  @override
  void initState() {
    super.initState();
    _convertDate();
  }

  void _convertNumberToArabic() {
    setState(() {
      _convertedNumber = NumberConverter.toArabic(_numberController.text);
    });
  }

  void _convertNumberToEnglish() {
    setState(() {
      _convertedNumber = NumberConverter.toEnglish(_numberController.text);
    });
  }

  void _convertDate() {
    setState(() {
      _hijriDate = DateConverter.toHijri(_selectedDate);
      _arabicFormattedDate = DateConverter.formatArabicDate(_selectedDate);
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _convertDate();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arabic Converters Demo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Number Conversion Section
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🔢 تحويل الأرقام',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _numberController,
                      decoration: const InputDecoration(
                        labelText: 'أدخل رقم (عربي أو إنجليزي)',
                        border: OutlineInputBorder(),
                        hintText: '123 or ١٢٣',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _convertNumberToArabic,
                            icon: const Text('🇸🇦'),
                            label: const Text('→ عربي'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _convertNumberToEnglish,
                            icon: const Text('🇬🇧'),
                            label: const Text('→ English'),
                          ),
                        ),
                      ],
                    ),
                    if (_convertedNumber.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _convertedNumber,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Date Conversion Section
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📅 تحويل التاريخ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _selectDate,
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('اختر تاريخ ميلادي'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Gregorian Date
                    _buildDateInfoCard(
                      '📆 التاريخ الميلادي',
                      _selectedDate.toString().split(' ')[0],
                      Colors.blue,
                    ),
                    const SizedBox(height: 12),

                    // Arabic Formatted Date
                    _buildDateInfoCard(
                      '🇸🇦 التاريخ بالعربي',
                      _arabicFormattedDate,
                      Colors.green,
                    ),
                    const SizedBox(height: 12),

                    // Hijri Date
                    if (_hijriDate != null) ...[
                      _buildDateInfoCard(
                        '🌙 التاريخ الهجري',
                        _hijriDate!.toArabicFormat(),
                        Colors.purple,
                      ),
                      const SizedBox(height: 12),
                      _buildDateInfoCard(
                        '🌙 Hijri Date (English)',
                        _hijriDate!.toEnglishFormat(),
                        Colors.orange,
                      ),
                      const SizedBox(height: 12),
                      _buildDateInfoCard(
                        '📊 التاريخ الرقمي الهجري',
                        _hijriDate!.toNumericFormat(),
                        Colors.teal,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Current Hijri Date Card
            Card(
              elevation: 4,
              color: Colors.amber.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.today,
                      size: 48,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'التاريخ الهجري اليوم',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateConverter.getCurrentHijriDate().toArabicFormat(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateInfoCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }
}
