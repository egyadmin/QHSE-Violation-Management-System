# QHSE Violation Management System - Flutter App
## نظام إدارة مخالفات QHSE

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![License](https://img.shields.io/badge/License-Proprietary-red.svg)

شامل لإدارة مخالفات الجودة والصحة والسلامة والبيئة (QHSE) مبني بتقنية Flutter.

---

## ✨ Features (المميزات)

### Core Features
- ✅ **13 دور وظيفي مختلف**: Admin, CEO, Officers, Managers, Project Manager
- ✅ **171 نوع مخالفة** موزعة على 4 تصنيفات رئيسية
- ✅ **4 تصنيفات QHSE**: السلامة (Safety), الصحة (Health), الجودة (Quality), البيئة (Environment)
- ✅ **نظام Workflow متقدم** لكل تصنيفQHSE
- ✅ **دعم كامل للغة العربية والإنجليزية** مع RTL support
- ✅ **Material Design 3** مع ألوان SAJCO المميزة
- ✅ **تكامل كامل مع API Backend**

### Currently Implemented (تم تنفيذه)
- ✅ نظام المصادقة (Login/Logout)
- ✅ لوحة التحكم الرئيسية
- ✅ إحصائيات سريعة
- ✅ بطاقات تصنيفات QHSE
- ✅ التبديل بين العربية والإنجليزية

### Coming Soon (قريباً)
- 🔜 شاشة قائمة المخالفات
- 🔜 شاشة إضافة مخالفة جديدة (8 خطوات)
- 🔜 شاشة تفاصيل المخالفة
- 🔜 نظام الموافقة/الرفض
- 🔜 الرسوم البيانية والتقارير
- 🔜 إدارة المستخدمين

---

## 🏗️ Project Structure

```
qhse_app/
├── lib/
│   ├── main.dart                    # نقطة البداية
│   ├── app.dart                     # تهيئة التطبيق
│   │
│   ├── core/                        # الطبقة الأساسية
│   │   ├── theme/                   # نظام التصميم
│   │   │   ├── app_colors.dart      # ألوان التطبيق
│   │   │   ├── app_gradients.dart   # التدرجات اللونية
│   │   │   └── app_theme.dart       # Theme configuration
│   │   ├── constants/               # الثوابت
│   │   │   ├── app_constants.dart   # إعدادات عامة
│   │   │   └── app_icons.dart       # الأيقونات
│   │   ├── l10n/                    # الترجمات
│   │   ├── routes/                  # التوجيه
│   │   └── utils/                   # أدوات مساعدة
│   │
│   ├── data/                        # طبقة البيانات
│   │   ├── models/                  # النماذج
│   │   │   ├── user_model.dart
│   │   │   ├── qhse_violation_model.dart
│   │   │   ├── violation_domain_model.dart
│   │   │   ├── violation_type_model.dart
│   │   │   └── project_model.dart
│   │   └── services/                # خدمات API
│   │       ├── api_client.dart
│   │       ├── auth_service.dart
│   │       ├── qhse_service.dart
│   │       └── projects_service.dart
│   │
│   ├── providers/                   # إدارة الحالة
│   │   └── auth_provider.dart
│   │
│   └── presentation/                # طبقة العرض
│       ├── screens/
│       │   ├── auth/
│       │   │   └── login_screen.dart
│       │   └── dashboard/
│       │       └── dashboard_screen.dart
│       └── widgets/
│
├── assets/
│   ├── images/
│   ├── icons/
│   └── translations/
│       ├── ar.json                  # الترجمة العربية
│       └── en.json                  # الترجمة الإنجليزية
│
└── pubspec.yaml                     # تكوين المشروع
```

---

## 📦 Dependencies (المكتبات المستخدمة)

### Core
- `flutter`: SDK
- `provider`: ^6.1.1 - State management
- `easy_localization`: ^3.0.3 - Localization

### Networking
- `dio`: ^5.4.0 - HTTP client

### Local Storage
- `shared_preferences`: ^2.2.2 - Local data
- `flutter_secure_storage`: ^9.0.0 - Secure token storage

### UI Components
- `flutter_spinkit`: ^5.2.0 - Loading animations
- `shimmer`: ^3.0.0 - Skeleton loading
- `cached_network_image`: ^3.3.1 - Image caching

### Charts & Maps
- `fl_chart`: ^0.66.0 - Charts
- `flutter_map`: ^6.1.0 - Maps
- `latlong2`: ^0.9.0 - Coordinates

### Forms & Validation
- `flutter_form_builder`: ^9.2.1
- `form_builder_validators`: ^9.1.0

### Utilities
- `intl`: ^0.18.1 - Date/time formatting
- `image_picker`: ^1.0.7 - Camera/gallery
- `file_picker`: ^6.1.1 - File selection

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- Android Studio / VS Code
- Android SDK / iOS SDK

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd qhse_app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure API URL**
Edit `lib/core/constants/app_constants.dart`:
```dart
static const String baseUrl = 'https://your-replit-url.replit.app';
```

4. **Run the app**
```bash
flutter run
```

---

## 🎨 Color Palette

### Primary Colors
- Primary Green: `#16A34A` (Green-600)
- Primary Dark: `#15803D` (Green-700)
- Primary Light: `#22C55E` (Green-500)

### QHSE Domain Colors
- Safety (السلامة): `#EF4444` (Red-500)
- Health (الصحة): `#10B981` (Emerald-500)
- Quality (الجودة): `#3B82F6` (Blue-500)
- Environment (البيئة): `#F59E0B` (Amber-500)

### Status Colors
- Draft: `#94A3B8` (Slate-400)
- Pending: `#F59E0B` (Amber-500)
- Approved: `#22C55E` (Green-500)
- Rejected: `#EF4444` (Red-500)
- Closed: `#3B82F6` (Blue-500)

---

## 🌐 Localization

The app supports both Arabic and English with RTL support for Arabic.

### Adding new translations
1. Edit `assets/translations/ar.json` for Arabic
2. Edit `assets/translations/en.json` for English
3. Use `'key'.tr()` in code to access translations

### Switching languages
```dart
// Switch to Arabic
context.setLocale(const Locale('ar', 'SA'));

// Switch to English
context.setLocale(const Locale('en', 'US'));
```

---

## 👥 User Roles

The system supports 13 different user roles:
1. User (مستخدم عادي)
2. Admin (مدير النظام)
3. CEO (الرئيس التنفيذي)
4. Safety Officer (مسؤول السلامة)
5. Quality Officer (مسؤول الجودة)
6. Health Officer (مسؤول الصحة المهنية)
7. Environment Officer (مسؤول البيئة)
8. Safety Manager (مدير السلامة)
9. Quality Manager (مدير الجودة)
10. Health Manager (مدير الصحة المهنية)
11. Environment Manager (مدير البيئة)
12. Project Manager (مدير المشروع)
13. HSE Manager (مدير HSE)

---

## 📱 Screens Overview

### 1. Login Screen (شاشة تسجيل الدخول)
- Email and password authentication
- Language toggle (Arabic/English)
- Auto-login support
- Create account link

### 2. Dashboard Screen (لوحة التحكم)
- User welcome card
- Quick stats (4 cards)
- QHSE domain cards
- New violation FAB button

### 3. Violations List (قريباً)
- Filter by domain
- Search functionality
- Pagination
- Status filters

### 4. New Violation Form (قريباً)
- 8-step wizard
- Domain selection
- Map integration
- Image upload

---

## 🔧 Configuration

### API Endpoints
All API endpoints are configured in `lib/core/constants/app_constants.dart`:
- Base URL
- Auth endpoints
- QHSE endpoints
- Timeouts

### Theme Customization
Colors and theme can be customized in:
- `lib/core/theme/app_colors.dart`
- `lib/core/theme/app_gradients.dart`
- `lib/core/theme/app_theme.dart`

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

---

## 📝 Development Status

### Phase 1: ✅ Complete
- Project structure
- Core configuration
- Authentication system
- Basic dashboard

### Phase 2: 🔜 In Progress
- Violations management
- QHSE domains
- Workflow system

### Phase 3: 📅 Planned
- Reports and analytics
- User management
- Training system

---

## 🤝 Contributing

This is a proprietary project. Contact the development team for contribution guidelines.

---

## 📞 Support

For technical support or questions:
- Email: support@sajco.com
- Documentation: See `implementation_plan.md`

---

## 📄 License

Proprietary - All rights reserved © SAJCO 2025

---

**Built with ❤️ using Flutter**

**Last Updated**: December 8, 2025
