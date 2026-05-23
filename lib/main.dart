import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator Sederhana',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const KalkulatorPage(),
    );
  }
}

class KalkulatorPage extends StatefulWidget {
  const KalkulatorPage({super.key});

  @override
  State<KalkulatorPage> createState() => _KalkulatorPageState();
}

class _KalkulatorPageState extends State<KalkulatorPage> {
  final TextEditingController _angka1 = TextEditingController();
  final TextEditingController _angka2 = TextEditingController();

  String _hasil = '';
  String _operator = '+';

  // ===== FUNGSI OPERASI =====
  double tambah(double a, double b) => a + b;
  double kurang(double a, double b) => a - b;
  double kali(double a, double b) => a * b;
  double bagi(double a, double b) => a / b;

  // ===== LOGIKA UTAMA =====
  void hitung() {
    setState(() {
      final input1 = _angka1.text.trim();
      final input2 = _angka2.text.trim();

      // VALIDASI KOSONG
      if (input1.isEmpty || input2.isEmpty) {
        _hasil = 'Input tidak boleh kosong.';
        return;
      }

      // PARSING
      final double? a = double.tryParse(input1);
      final double? b = double.tryParse(input2);

      // VALIDASI ANGKA
      if (a == null || b == null) {
        _hasil = 'Input harus berupa angka.';
        return;
      }

      // VALIDASI PEMBAGIAN NOL
      if (_operator == '/' && b == 0) {
        _hasil = 'Tidak dapat membagi dengan nol.';
        return;
      }

      double result;

      switch (_operator) {
        case '+':
          result = tambah(a, b);
          break;
        case '-':
          result = kurang(a, b);
          break;
        case '*':
          result = kali(a, b);
          break;
        case '/':
          result = bagi(a, b);
          break;
        default:
          result = 0;
      }

      // FORMAT HASIL (biar gak 2.000000)
      _hasil = result.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '');
    });
  }

  @override
  void dispose() {
    _angka1.dispose();
    _angka2.dispose();
    super.dispose();
  }

  // ===== UI =====
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Sederhana'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // INPUT 1
            TextField(
              controller: _angka1,
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Angka pertama',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // INPUT 2
            TextField(
              controller: _angka2,
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Angka kedua',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // DROPDOWN OPERATOR
            DropdownButtonFormField<String>(
              value: _operator,
              decoration: const InputDecoration(
                labelText: 'Pilih Operasi',
                border: OutlineInputBorder(),
              ),
              items: ['+', '-', '*', '/']
                  .map((op) => DropdownMenuItem(
                value: op,
                child: Text(op),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _operator = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            // BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: hitung,
                child: const Text('Hitung'),
              ),
            ),

            const SizedBox(height: 25),

            // HASIL
            Text(
              _hasil.isEmpty ? 'Hasil akan muncul di sini' : 'Hasil: $_hasil',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: (_hasil.contains('tidak') ||
                    _hasil.contains('harus') ||
                    _hasil.contains('Tidak'))
                    ? Colors.red
                    : Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}