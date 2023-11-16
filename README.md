# anugerah Mobile
## Setup

- VS Code
- Android Studio & Flutter SDK
Cara install: [https://www.youtube.com/watch?v=asNdz10WR6w](https://www.youtube.com/watch?v=asNdz10WR6w&ab_channel=EricoDarmawanHandoyo)
    - Gunakan Flutter versi `3.10.6` melalui **FVM** atau download di **Flutter SDK Archive** ([link](https://docs.flutter.dev/release/archive?tab=windows)). Pada bagian **Stable channel (Windows)**, cari versi tersebut atau gunakan link berikut ini:
        - https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.10.6-stable.zip
    - Android SDK:
        - Minimum: `33`
- FVM - Flutter Version Management
Cara install: https://www.youtube.com/watch?v=4AwusVAsMPU
- Membuat AVD (Android Virtual Device)
Cara membuat: [https://www.youtube.com/watch?v=YBw0kEPcfEA](https://www.youtube.com/watch?v=YBw0kEPcfEA&ab_channel=AndroidRion)

- Cara membuat: [https://www.youtube.com/watch?v=YBw0kEPcfEA](https://www.youtube.com/watch?v=YBw0kEPcfEA&ab_channel=AndroidRion)

## Menjalankan Aplikasi

- Masuk ke dir `/anugerah-mobile/`
- Jalankan perintah berikut:
    
    ```bash
    flutter pub get
    ```
    
- Periksa devices yang tersedia dengan perintah `flutter devices`
    
    ```bash
    2 connected devices:
    
    macOS (desktop) • macos  • darwin-x64     • macOS 13.4.1 22F82 darwin-x64
    Chrome (web)    • chrome • web-javascript • Google Chrome 114.0.5735.198
    ```
    
- Bila tidak terdapat device `(mobile)`, periksa emulator yang tersedia dengan perintah `flutter emulators`
    
    ```bash
    3 available emulators:
    
    apple_ios_simulator    • iOS Simulator          • Apple  • ios
    Asus_Max_Pro_M1_API_31 • Asus Max Pro M1 API 31 • User   • android
    Pixel_2_API_30         • Pixel 2 API 30         • Google • android
    
    To run an emulator, run 'flutter emulators --launch <emulator id>'.
    To create a new emulator, run 'flutter emulators --create [--name xyz]'.
    
    You can find more information on managing emulators at the links below:
      https://developer.android.com/studio/run/managing-avds
      https://developer.android.com/studio/command-line/avdmanager
    ```
    
- Pada result di atas, kita memiliki opsi dengan `emulator id` berikut:
    - `apple_ios_simulator`
    - `Asus_Max_Pro_M1_API_31`
    - `Pixel_2_API_30`
 
- Jalankan emulator dengan perintah `flutter emulators --launch Asus_Max_Pro_M1_API_31`

    <img width="300" src="https://github.com/lbiosys/anugerah-mobile/assets/3750495/eb170cb7-6035-49a6-9bdb-4b5fb26acd28" />
    
- Periksa kembali devices yang tersedia dengan perintah `flutter devices`
    
    ```bash
    3 connected devices:
    
    sdk gphone64 x86 64 (mobile) • emulator-5554 • android-x64    • Android 12 (API 31) (emulator)
    macOS (desktop)              • macos         • darwin-x64     • macOS 13.4.1 22F82 darwin-x64
    Chrome (web)                 • chrome        • web-javascript • Google Chrome 114.0.5735.198
    ```
    
- Pada result di atas, kita sudah memiliki device `(mobile)` dengan id `emulator-5554`
- Jalankan project dengan perintah berikut:

    ```bash
    flutter run -d emulator-5554
    ```
    <img width="300" src="https://github.com/lbiosys/anugerah-mobile/assets/3750495/efff99d7-64fd-4d35-adad-a61ba99c4afb" />


## Build Aplikasi Mobile

Untuk build project `anugerah-mobile`, jalankan perintah berikut:

```bash
flutter build apk
```

## Rilis Aplikasi ke Play Store

### Persiapan sebelum build

1. Download file-file yang dibutuhkan di [Link berikut](https://drive.google.com/drive/u/0/folders/1D-zl-z9LuCh4pQya2X0mMaWYlln6KBKq)

    <img width="500" src="https://github.com/lbiosys/anugerah-mobile/assets/3750495/58cd1676-052a-4fc5-9c50-72d05bc8430e" />

2. Copy file-file tersebut ke lokasi berikut:
    ```
    ./android/
            ⎿ key.properties

    ./android/app/
                ⎿ google-services.json
                ⎿ upload-keystore-anugerah-mobile.keystore
    ```

### Build aplikasi
1. Update file-file berikut dengan menambahkan digit terakhir `Version Code`
    - `pubspec.yaml`
        ```
        # Before
        version: 1.0.0+8

        # After
        version: 1.0.0+9
        ```
    - `./android/local.properties.production` dan `./android/local.properties.staging` 
        ```
        # Before
        flutter.versionName=1.0.0
        flutter.versionCode=8

        # After
        flutter.versionName=1.0.0
        flutter.versionCode=9
        ```
2. Jalankan perintah berikut untuk memperbarui `local.properties`:
   ```
    $ sh scripts/setup-prod.sh
   ```
3. Jalankan perintah berikut untuk build AppBundle:
   ```
    $ flutter build appbundle
   ```
4. Upload file `app-release.aab` ke Play Store

### Catatan
- Untuk rilis aplikasi baru ke Play Store selanjutnya, tinggal ikuti bagian `Build Aplikasi`.
- `App Version` (contoh: `1.0.0`) dapat menyesuaikan.
- `Version Code` diisi tergantung appbundle terakhir yang di upload ke Play Store. Misal terakhir `8`, maka kita perlu mengubah `Version Code` ke minimal `9`.
- Contoh PR release Aplikasi [di sini](https://github.com/lbiosys/anugerah-mobile/pull/19).
- Detail referensi: https://docs.flutter.dev/deployment/android.
