# QHSE Flutter App - Development Notes
## ملاحظات التطوير

---

## 🎯 الحالة الحالية للمشروع

### ✅ تم إنجازه (Completed)

#### 1. البنية الأساسية للمشروع
- [x] إنشاء هيكل المجلدات الكامل
- [x] تكوين `pubspec.yaml` مع جميع المكتبات المطلوبة
- [x] إعداد نظام الألوان (AppColors, QHSEColors, StatusColors, RoleColors)
- [x] إنشاء التدرجات اللونية (Gradients)
- [x] تكوين Theme Material 3 الكامل

#### 2. نماذج البيانات (Data Models)
- [x] `User` model مع 13 دور وظيفي
- [x] `ViolationDomain` model للتصنيفات الأربعة
- [x] `ViolationType` model لـ 171 نوع مخالفة
- [x] `QhseViolation` model الشامل مع جميع الحقول
- [x] `Project` model مع حالات المشروع

#### 3. طبقة الخدمات (Services Layer)
- [x] `ApiClient` مع Dio و Interceptors كاملة
- [x] `AuthService` (login, register, logout, token management)
- [x] `QhseService` (violations, domains, types, approve/reject)
- [x] `ProjectsService` (list, search, getById)

#### 4. إدارة الحالة (State Management)
- [x] `AuthProvider` مع Provider pattern
- [x] نظام إدارة حالة المصادقة الكامل

#### 5. الشاشات المطورة (Screens)
- [x] `LoginScreen` مع validation كامل
- [x] `DashboardScreen` مع إحصائيات وبطاقات QHSE
- [x] دعم RTL والتبديل بين اللغات

#### 6. التوطين (Localization)
- [x] ملفات الترجمة العربية والإنجليزية
- [x] إعداد easy_localization
- [x] دعم RTL كامل

---

## 🚧 التالي للتطوير (Next Steps)

### المرحلة القادمة: Violations Management

#### 1. نماذج إضافية مطلوبة
```dart
- [ ] Equipment model
- [ ] Driver model
- [ ] WorkflowStage model
- [ ] WorkflowHistory model  
- [ ] Notification model
- [ ] Attachment model
```

#### 2. Providers إضافية
```dart
- [ ] ViolationsProvider
- [ ] ProjectsProvider
- [ ] LanguageProvider (optional)
```

#### 3. شاشات المخالفات
```dart
- [ ] ViolationsListScreen
  - Filter tabs (All, Safety, Health, Quality, Environment)
  - Search functionality
  - Pagination
  - Status filters
  
- [ ] NewViolationScreen (8 steps)
  - Step 1: Domain selection
  - Step 2: Sub-category (Safety only)
  - Step 3: Violation type
  - Step 4: Employee selection
  - Step 5: Project selection
  - Step 6: Location & details (with map)
  - Step 7: Classification
  - Step 8: Attachments
  
- [ ] ViolationDetailScreen
  - Workflow progress indicator
  - Information cards
  - Approve/Reject buttons
  - History timeline
```

#### 4. Widgets مطلوبة
```dart
- [ ] DomainBadge
- [ ] StatusBadge
- [ ] SeverityBadge
- [ ] WorkflowProgressWidget
- [ ] LocationPickerWidget (with flutter_map)
- [ ] ImagePickerWidget
- [ ] AutocompleteSearchWidget
```

---

## ⚙️ إعدادات مهمة

### API Configuration
```dart
// في lib/core/constants/app_constants.dart
// يجب تحديث baseUrl بعنوان Replit الخاص بك
static const String baseUrl = 'https://your-app-name.replit.app';
```

### التشغيل
```bash
# تثبيت المكتبات
flutter pub get

# تشغيل التطبيق
flutter run

# بناء APK
flutter build apk --release
```

---

## 🎨 نظام التصميم المطبق

### الألوان الرئيسية
- Primary: #16A34A (Green-600)
- Safety: #EF4444 (Red-500)
- Health: #10B981 (Emerald-500)
- Quality: #3B82F6 (Blue-500)
- Environment: #F59E0B (Amber-500)

### Material Design 3
- تم تطبيق Theme كامل
- Cards مع elevation و rounded corners
- Buttons مع gradients
- Input fields مع styling موحد

---

## 📝 ملاحظات تطويرية

### 1. المصادقة (Authentication)
- الـ token يتم تخزينه بشكل آمن في `FlutterSecureStorage`
- بيانات المستخدم تُخزن في `SharedPreferences`
- Auto-login يعمل عند فتح التطبيق
- التحقق من صلاحية الـ token يتم تلقائياً

### 2. إدارة الحالة
- استخدام Provider pattern (بسيط وفعال)
- يمكن التبديل لـ Bloc إذا احتجنا لتعقيد أكبر
- State يُحفظ في الـ Provider ولا يُفقد

### 3. API Integration
- جميع الـ endpoints موجودة في `app_constants.dart`
- Error handling موحد في `ApiClient`
- Logging للـ requests والـ responses
- Interceptors للـ auth token

### 4. الترجمة (i18n)
- استخدام easy_localization
- ملفات JSON للترجمات
- التبديل بين اللغات يحفظ الاختيار
- RTL يعمل تلقائياً للعربية

### 5. الأداء
- استخدام const constructors حيثما أمكن
- Lazy loading للقوائم الطويلة
- Image caching للصور
- Minimal rebuilds

---

## ⚡ نصائح للتطوير

### عند إضافة شاشة جديدة:
```dart
1. إنشاء الـ screen في المجلد المناسب
2. إضافة الـ route في app.dart إذا لزم
3. Create provider if needed
4. Add translations to ar.json & en.json
5. Test with both languages
6. Test RTL layout
```

### عند إضافة model جديد:
```dart
1. Create model class
2. Add fromJson() & toJson()
3. Add to services if API call needed
4. Test JSON parsing
```

### عند إضافة service جديد:
```dart
1. Create service class
2. Use ApiClient for HTTP calls
3. Add error handling
4. Add to provider if state management needed
```

---

## 🐛 مشاكل معروفة و حلولها

### 1. Flutter not recognized
```bash
# الحل: تثبيت Flutter SDK وإضافته للـ PATH
# أو استخدام Android Studio / VS Code مع Flutter plugin
```

### 2. Package conflicts
```bash
# الحل: حذف pubspec.lock وتشغيل
flutter clean
flutter pub get
```

### 3. RTL issues
```dart
// تأكد من استخدام Directionality widget
Directionality(
  textDirection: TextDirection.rtl,
  child: YourWidget(),
)
```

---

## 📚 الموارد المفيدة

### Documentation
- Flutter: https://flutter.dev/docs
- Dio: https://pub.dev/packages/dio
- Provider: https://pub.dev/packages/provider
- EasyLocalization: https://pub.dev/packages/easy_localization

### Design
- Material Design 3: https://m3.material.io/
- Flutter Icons: https://api.flutter.dev/flutter/material/Icons-class.html

---

## 🔄 Git Workflow (Recommended)

```bash
# Feature branch
git checkout -b feature/violations-list

# Commit frequently
git add .
git commit -m "feat: add violations list screen"

# Push to remote
git push origin feature/violations-list

# Merge to main after review
```

---

## 📊 Progress Tracking

### Week 1 (8 Dec - 14 Dec) ✅
- [x] Project setup
- [x] Core configuration
- [x] Authentication
- [x] Basic dashboard

### Week 2 (15 Dec - 21 Dec) 🔜
- [ ] Violations list
- [ ] New violation form
- [ ] Violation details
- [ ] Map integration

### Week 3 (22 Dec - 28 Dec) 📅
- [ ] Reports
- [ ] Analytics
- [ ] Charts integration
- [ ] User management

---

**آخر تحديث**: 8 ديسمبر 2025
**الحالة**: Phase 1 Complete ✨
**التالي**: Violations Management System
