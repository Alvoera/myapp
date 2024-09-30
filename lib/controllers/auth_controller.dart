import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi untuk login
  Future<void> login(String username) async {
    if (username.isEmpty) {
      Get.snackbar('Error', 'Username tidak boleh kosong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.black);
      return;
    }

    // Cek apakah id_nakes ada di Firestore
    try {
      // Ambil data dari collection 'nakes' dimana id_nakes = username
      var snapshot = await _firestore
          .collection('nakes')
          .where('id_nakes', isEqualTo: username)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Jika id_nakes ditemukan, login berhasil
        isLoggedIn.value = true;
        Get.offNamed('/input-data'); // Arahkan ke halaman input data
      } else {
        // Jika id_nakes tidak ditemukan, tampilkan pesan error
        Get.snackbar('Error', 'ID Nakes tidak sesuai',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black);
      }
    } catch (e) {
      // Jika ada kesalahan saat mengambil data dari Firestore
      Get.snackbar('Error', 'Terjadi kesalahan saat login',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.black);
    }
  }
}
