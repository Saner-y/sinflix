# 🎬 SinFlix Dating App Case Study — Flutter Developer | Nodelabs

Bu proje, Nodelabs tarafından Flutter Developer pozisyonu için hazırlanan teknik değerlendirme kapsamında geliştirilmiştir. Projede, kullanıcıların film temelli bir “dating app” deneyimi yaşaması amaçlanmaktadır. Giriş/kayıt, ana sayfa akışı, favori işlemleri, profil bilgileri gibi temel akışlar Flutter ile modern ve sürdürülebilir mimari yapılar kullanılarak geliştirilmiştir.

---

## 🚀 Özellikler

### 🔐 Kimlik Doğrulama
- Kullanıcı kayıt ve giriş işlemleri
- Token'ın `FlutterSecureStorage` ile güvenli saklanması
- Başarılı giriş sonrası otomatik yönlendirme

### 🏠 Ana Sayfa (Keşfet)
- Sonsuz kaydırma (infinite scroll)
- Sayfa başına 5 film
- Pull-to-refresh özelliği
- Favori butonları ile anlık UI güncellemesi
- Lottie animasyonları

### 👤 Profil Sayfası
- Kullanıcı bilgilerinin görüntülenmesi
- Favori filmlerin listelenmesi
- Profil fotoğrafı yükleme özelliği

### 🌐 Navigasyon
- `BottomNavigationBar` ile ekranlar arası geçiş
- `GoRouter` ile named route navigasyonu
- Ekran state'lerinin korunması

---

## 🧱 Mimari Yapı

Proje, **Clean Architecture** ve **MVVM prensiplerine** uygun olarak aşağıdaki şekilde yapılandırılmıştır:

```
lib/
├── core/          # Temalar, lokalizasyon, ağ, DI, logger, yardımcı fonksiyonlar   
├── bloc/          # Bloc ve Cubit yapıları (ViewModel işlevi)
├── view/          # Ekranlar (View)
├── components/    # Reusable UI bileşenleri
└── main.dart
```

### ✅ MVVM + Bloc Kullanımı
- Bloc yapıları, MVVM mimarisinde `ViewModel` görevini üstlenir.
- UI katmanı `view/`, durum yönetimi ise `bloc/` içinde izole edilmiştir.
- Örnekler:
    - `LoginBloc`, `RegisterBloc`, `ProfileBloc`, `HomeBloc`
    - `ThemeCubit`, `LanguageBloc`

### ⚠️ Domain ve UseCase Katmanı
Bu projede `domain` ve `usecase` katmanları **bilinçli olarak dahil edilmemiştir**.

**Neden?**
- Proje küçük ve sınırlı kapsamlı olduğu için katman sayısı sade tutulmuştur.
- İş mantıkları Bloc yapısı içerisinde ayrıştırılmıştır.
- Bu tercih, kodun okunabilirliğini ve bakım kolaylığını artırmak için yapılmıştır.
- Daha büyük projelerde `usecase`, `domain` gibi yapılar elbette tercih edilmelidir.

---

## 🎁 Bonus Özellikler

| Özellik                            | Durum |
|------------------------------------|-------|
| 🎨 Custom Theme                    | ⚠️    |
| 🌐 Localization (TR/EN)            | ✅     |
| 🔀 Navigation Service (`GoRouter`) | ✅     |
| 📦 Dependency Injection            | ✅     |
| 🔐 Secure Token Storage            | ✅     |
| 📸 Profil Fotoğrafı Upload         | ✅     |
| 📊 Firebase Crashlytics            | ✅     |
| 🪄 Splash Screen                   | ✅     |
| 🎞️ Lottie Animasyonları           | ✅     |
| 🧾 Logger Service (`Logger`)       | ✅     |

---

## 🛠️ Kullanılan Teknolojiler

- Flutter
- Dart
- Firebase (Auth, Crashlytics)
- Bloc / Cubit
- GoRouter
- FlutterSecureStorage
- Lottie
- Easy Localization
- Logger

---

## 📄 Kurulum

```bash
git clone <repo-link>
cd dating_app
flutter pub get
flutter run
```

> Not: Firebase entegrasyonu için `google-services.json` ve `GoogleService-Info.plist` dosyalarının uygun şekilde projeye eklenmesi gerekmektedir.

---

## 👤 Geliştirici

**Saner Yeşil**  
📧 [saneryesil@hotmail.com]  
🔗 [https://www.linkedin.com/in/saneryesil ]
🔗 [https://www.github.com/Saner-y]

---

## 📝 Not

Bu proje tamamen kurgusaldır. Yalnızca teknik değerlendirme amacıyla hazırlanmış olup gerçek bir ürün değildir.
