import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void saveData(String noJkn, String beratBadan, String umur, DateTime tanggalKunjungan) async {
    // Membuat map data yang akan disimpan
    Map<String, dynamic> data = {
      'no_jkn': noJkn,
      'berat_badan': beratBadan,
      'umur': umur,
      'tanggal_kunjungan': tanggalKunjungan,
    };

    try {
      // Menyimpan data ke dalam koleksi 'user'
      await _firestore.collection('user').add(data);

      // Menampilkan dialog sukses
      Get.defaultDialog(
        title: 'Data Berhasil Disimpan',
        middleText: 'Ingin Input Data Lagi atau Logout?',
        textConfirm: 'Input Lagi',
        textCancel: 'Logout',
        onConfirm: () {
          Get.back(); // Kembali ke halaman input data
        },
        onCancel: () {
          Get.offAllNamed('/login'); // Logout dan kembali ke halaman login
        },
      );
    } catch (e) {
      // Menampilkan pesan error jika terjadi kesalahan saat menyimpan data
      Get.snackbar('Error', 'Gagal menyimpan data: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
