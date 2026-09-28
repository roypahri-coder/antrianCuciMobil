import 'dart:io';

class CuciMobilSystem {
  final int maxPos = 5;
  final Map<int, String> posMap = {};
  final List<String> waitingList = [];

  // Fungsi khusus untuk validasi format Plat Nomor
  bool isValidPlat(String plat) {
    String cleanPlat = plat.trim().toUpperCase();

    // 1. Cek panjang minimal (Plat nomor minimal 3 karakter, misal: "B 1 A")
    if (cleanPlat.length < 3) {
      return false;
    }

    // 2. RegEx Plat Nomor Indonesia:
    // - 1-2 huruf di depan (Kode Wilayah)
    // - Spasi opsional
    // - 1-4 digit angka
    // - Spasi opsional
    // - 1-3 huruf di belakang (Seri)
    RegExp platRegex = RegExp(r'^[A-Z]{1,2}\s?\d{1,4}\s?[A-Z]{1,3}$');

    return platRegex.hasMatch(cleanPlat);
  }

  // 1. Menambahkan antrian mobil
  void tambahMobil(String plat) {
    String formattedPlat = plat.trim().toUpperCase();

    if (posMap.length < maxPos) {
      int posTersedia = 1;
      while (posMap.containsKey(posTersedia)) {
        posTersedia++;
      }
      posMap[posTersedia] = formattedPlat;
      print("✅ [$formattedPlat] LANGSUNG masuk ke Pos $posTersedia.");
    } else {
      waitingList.add(formattedPlat);
      print("⏳ Semua Pos penuh! [$formattedPlat] masuk ke Waiting List.");
    }
  }

  // 2. Lihat Waiting List
  void lihatWaitingList() {
    print("\n---------------------------------------------");
    print("📋 DAFTAR WAITING LIST (${waitingList.length} Kendaraan)");
    print("---------------------------------------------");
    if (waitingList.isEmpty) {
      print("   (Kosong / Tidak ada kendaraan menunggu)");
    } else {
      for (int i = 0; i < waitingList.length; i++) {
        print("   ${i + 1}. ${waitingList[i]}");
      }
    }
    print("---------------------------------------------\n");
  }

  // 3. Lihat Pos
  void lihatPos() {
    print("\n---------------------------------------------");
    print("🚗 DAFTAR POS PENCUCIAN (${posMap.length}/$maxPos)");
    print("---------------------------------------------");
    for (int i = 1; i <= maxPos; i++) {
      if (posMap.containsKey(i)) {
        print("   Pos $i: ${posMap[i]}");
      } else {
        print("   Pos $i: (Kosong)");
      }
    }
    print("---------------------------------------------\n");
  }

  // 4. Selesaikan Pos
  void selesaikanPos() {
    if (posMap.isEmpty) {
      print("\n⚠️ Tidak ada mobil di Pos Pencucian yang sedang dicuci.");
      return;
    }

    print("\n--- POS YANG SEDANG TERISI ---");
    posMap.forEach((pos, plat) {
      print("   Pos $pos: $plat");
    });
    stdout.write("Pilih nomor Pos yang selesai (1-5): ");

    String? inputPos = stdin.readLineSync();
    int? nomorPos = int.tryParse(inputPos ?? '');

    if (nomorPos == null || !posMap.containsKey(nomorPos)) {
      print("⚠️ Nomor Pos tidak valid atau Pos tersebut sedang kosong!");
      return;
    }

    String mobilSelesai = posMap.remove(nomorPos)!;
    print("\n✨ Mobil [$mobilSelesai] di Pos $nomorPos Selesai Dicuci!");

    if (waitingList.isNotEmpty) {
      String mobilMasuk = waitingList.removeAt(0);
      posMap[nomorPos] = mobilMasuk;
      print("🔄 Mobil [$mobilMasuk] dari Waiting List otomatis MASUK mengisi Pos $nomorPos.");
    }
  }
}

void main() {
  final sistem = CuciMobilSystem();
  var jalan = true;

  while (jalan) {
    print("\n================ MENU PENCUCIAN ================");
    print("1. Tambah Antrian Mobil");
    print("2. Lihat Waiting List");
    print("3. Lihat Pos");
    print("4. Selesaikan Pos");
    print("5. Keluar Program");
    print("================================================");
    stdout.write("Pilih menu (1-5): ");

    String? pilihan = stdin.readLineSync();

    switch (pilihan) {
      case '1':
        stdout.write("Masukkan Nomor Plat: ");
        String? plat = stdin.readLineSync();

        // Pengecekan input tidak boleh null/kosong dan harus lulus validasi format
        if (plat != null && sistem.isValidPlat(plat)) {
          sistem.tambahMobil(plat);
        } else {
          print("⚠️ Plat nomor tidak valid!");
          print("   Contoh format yang benar: KB 1000 AA, B 1234 CD, D 1 A");
          print("   (Tidak boleh hanya 1 huruf/angka atau tanpa pola plat nomor)");
        }
        break;

      case '2':
        sistem.lihatWaitingList();
        break;

      case '3':
        sistem.lihatPos();
        break;

      case '4':
        sistem.selesaikanPos();
        break;

      case '5':
        print("Terima kasih! Program selesai.");
        jalan = false;
        break;

      default:
        print("⚠️ Pilihan tidak valid, silakan coba lagi.");
    }
  }
}