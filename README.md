# Chain Fit App

**Chain Fit** adalah aplikasi Gym Hub & Management yang dikembangkan sebagai Tugas Besar mata kuliah Pemrograman Perangkat Bergerak (PPB). Aplikasi ini memudahkan pengguna untuk mencari gym, mendaftar keanggotaan (membership), mengakses video panduan latihan, dan mengelola profil kebugaran mereka.

## 📱 Fitur Utama (Features)

Aplikasi ini memiliki berbagai fitur modul yang terintegrasi:

*   **Autentikasi (Auth)**:
    *   Login dan Register pengguna.
    *   Manajemen sesi aman menggunakan token.
*   **Dashboard**:
    *   Halaman utama yang menampilkan ringkasan aktivitas dan menu cepat.
*   **Pencarian Gym (Search Gym)**:
    *   Cari lokasi gym terdekat atau berdasarkan kriteria tertentu.
    *   Integrasi lokasi (Geolocator).
*   **Detail Gym (Gym Preview)**:
    *   Melihat fasilitas, harga paket, dan deskripsi gym.
*   **Keanggotaan (Membership)**:
    *   Pendaftaran membership baru.
    *   **Status Membership**: Melihat status aktif/tidak aktif membership pengguna.
*   **QR Code**:
    *   **Generate QR**: Untuk akses masuk gym (check-in) bagi member.
    *   Fitur scan (jika diimplementasikan untuk sisi admin/gym).
*   **Video Panduan**:
    *   Kumpulan video tutorial latihan fisik.
    *   Pemutar video terintegrasi (Youtube Player / Video Player).
*   **Pembayaran (Payment)**:
    *   Alur pembayaran untuk berlangganan membership.
*   **Profil Pengguna**:
    *   Manajemen data diri dan pengaturan akun.
*   **Onboarding**:
    *   Layar pengenalan aplikasi untuk pengguna baru.

## 🛠️ Teknologi yang Digunakan (Tech Stack)

Project ini dibangun menggunakan **Flutter** dengan bahasa pemrograman **Dart**.

### Core Framework
*   **Flutter SDK**: ^3.x (Dart SDK ^3.x)

### State Management & Architecture
*   **Architecture**: Feature-first MVVM (Model-View-ViewModel) / Clean Architecture.
    *   `lib/core`: Komponen shared, konstanta, dan utilitas.
    *   `lib/features`: Modul fitur terpisah (View, ViewModel, Service/Repo).
*   **Provider**: `^6.0.5` untuk Dependency Injection dan State Management.

### UI Components
*   **Shadcn Flutter**: `^0.0.44` untuk komponen UI yang modern dan konsisten (porting dari shadcn/ui).
*   **Cupertino Icons** & **Material Design**.

### Networking & Data
*   **Dio**: `^5.5.0` untuk HTTP client request yang robust.
*   **HTTP**: `^1.6.0` sebagai client alternatif/tambahan.
*   **Shared Preferences**: `^2.5.3` untuk penyimpanan data lokal sederhana.
*   **Flutter Secure Storage**: `^8.0.0` untuk penyimpanan data sensitif (token).

### Integrasi & Utilities
*   **Google Login**: Integrasi login sosial (via konfigurasi environment).
*   **Flutter Dotenv**: `^5.1.0` untuk manajemen Environment Variable (`.env`).
*   **Intl**: Format tanggal dan angka.
*   **Image Picker**: Upload foto/gambar.
*   **Geolocator**: Akses lokasi pengguna.
*   **Webview Flutter**: Menampilkan konten web dalam aplikasi.
*   **QR Flutter**: Generate QR Code.

### Media
*   **Video Player** & **Chewie**: Pemutar video custom.
*   **Youtube Player Flutter**: Integrasi video YouTube.

## 📂 Struktur Project (Folder Structure)

Struktur folder mengikuti pola Feature-first untuk skalabilitas:

```
lib/
├── core/               # Kode yang digunakan bersama (API Client, Constants, Utils)
├── features/           # Modul fitur (setiap fitur memiliki views, viewmodels, models sendiri)
│   ├── auth/
│   ├── dashboard/
│   ├── gym_preview/
│   ├── membership/
│   ├── payment/
│   ├── profile/
│   ├── qr_code/
│   ├── search_gym/
│   ├── video_panduan/
│   └── ...
├── main.dart           # Entry point aplikasi
└── ...
```

## 🚀 Cara Menjalankan (Getting Started)

### Prasyarat
1.  **Flutter SDK** sudah terinstall dan dikonfigurasi di path system.
2.  **Android Studio** / **VS Code** dengan ekstensi Flutter/Dart.
3.  Emulator Android/iOS atau Physical Device.

### Instalasi
1.  Clone repository ini (atau ekstrak zip).
2.  Buka terminal di root project.
3.  Install dependencies:
    ```bash
    flutter pub get
    ```

### Konfigurasi Environment
Project ini menggunakan file `.env` untuk menyimpan konfigurasi sensitif (seperti Base URL API, Client ID Google, dll).
1.  Buat file `.env` di root folder (sejajar dengan `pubspec.yaml`).
2.  Salin isi dari `.env.example` (jika ada) atau minta kredensial kepada tim pengembang.
    ```env
    BASE_URL=https://api.example.com
    VITE_GOOGLE_CLIENT_ID=your_google_client_id
    ...
    ```

### Menjalankan Aplikasi
Jalankan perintah berikut untuk mode debug:
```bash
flutter run
```

---
**Tugas Besar Pemrograman Perangkat Bergerak (SE-47-01)**
*Telkom University*
