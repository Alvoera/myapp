import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import untuk TextInputFormatter
import 'package:get/get.dart';
import 'package:myapp/controllers/data_controller.dart';
import 'package:intl/intl.dart'; // Library untuk format tanggal

class InputDataPage extends StatefulWidget {
  @override
  _InputDataPageState createState() => _InputDataPageState();
}

class _InputDataPageState extends State<InputDataPage> {
  final TextEditingController _noJknController = TextEditingController();
  final TextEditingController _beratBadanController = TextEditingController();
  final TextEditingController _umurController = TextEditingController();
  final DataController _dataController = Get.put(DataController());

  // Variabel untuk menyimpan tanggal kunjungan
  DateTime? _selectedDate;
  final DateFormat _dateFormatter = DateFormat('dd-MM-yyyy');

  // Variabel untuk validasi input
  bool _noJknValid = true;
  bool _beratBadanValid = true;
  bool _umurValid = true;
  bool _tanggalKunjunganValid = true;

  // Fungsi untuk menampilkan date picker
  Future<void> _pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _tanggalKunjunganValid = true;
      });
    }
  }

  // Fungsi untuk mengosongkan semua input setelah data disimpan
  void _clearInputs() {
    _noJknController.clear();
    _beratBadanController.clear();
    _umurController.clear();
    setState(() {
      _selectedDate = null;
    });
  }

  // Fungsi untuk validasi input
  bool _validateInputs() {
    bool beratBadanIsValid =
        double.tryParse(_beratBadanController.text) != null;

    setState(() {
      _noJknValid = _noJknController.text.isNotEmpty;
      _beratBadanValid =
          _beratBadanController.text.isNotEmpty && beratBadanIsValid;
      _umurValid = _umurController.text.isNotEmpty;
      _tanggalKunjunganValid = _selectedDate != null;
    });

    // Mengembalikan true jika semua input valid
    return _noJknValid &&
        _beratBadanValid &&
        _umurValid &&
        _tanggalKunjunganValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Input Data User',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Input untuk No JKN
              TextField(
                controller: _noJknController,
                decoration: InputDecoration(
                  labelText: 'No JKN',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _noJknValid ? Colors.grey : Colors.red,
                    ),
                  ),
                  errorText: _noJknValid ? null : 'No JKN wajib diisi',
                ),
              ),
              const SizedBox(height: 10),

              // Input untuk Berat Badan
              TextField(
                controller: _beratBadanController,
                decoration: InputDecoration(
                  labelText: 'Berat Badan (kg)',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _beratBadanValid ? Colors.grey : Colors.red,
                    ),
                  ),
                  errorText: _beratBadanValid
                      ? null
                      : 'Berat Badan wajib diisi dan berupa angka',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
              ),
              const SizedBox(height: 10),

              // Input untuk Umur
              TextField(
                controller: _umurController,
                decoration: InputDecoration(
                  labelText: 'Umur (bulan)',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _umurValid ? Colors.grey : Colors.red,
                    ),
                  ),
                  errorText: _umurValid ? null : 'Umur wajib diisi',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),

              // Input untuk Tanggal Kunjungan
              GestureDetector(
                onTap: () => _pickDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: _selectedDate == null
                          ? 'Tanggal Kunjungan'
                          : 'Tanggal Kunjungan: ${_dateFormatter.format(_selectedDate!)}',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              _tanggalKunjunganValid ? Colors.grey : Colors.red,
                        ),
                      ),
                      suffixIcon: const Icon(Icons.calendar_today),
                      errorText: _tanggalKunjunganValid
                          ? null
                          : 'Tanggal wajib dipilih',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tombol untuk Simpan Data
              ElevatedButton(
                onPressed: () {
                  // Validasi semua input
                  if (_validateInputs()) {
                    // Simpan data jika semua validasi terpenuhi
                    _dataController.saveData(
                      _noJknController.text,
                      _beratBadanController.text,
                      _umurController.text,
                      _selectedDate!,
                    );

                    // Bersihkan input setelah menyimpan data
                    _clearInputs();
                    Get.snackbar('Berhasil', 'Data berhasil disimpan',
                        snackPosition: SnackPosition.BOTTOM);
                  } else {
                    Get.snackbar(
                        'Error', 'Periksa semua input yang wajib diisi',
                        snackPosition: SnackPosition.BOTTOM);
                  }
                },
                child: const Text('Simpan Data'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
