# مشكلة الاتصال بـ API - التشخيص والحل

## 🔴 المشكلة الحالية:

التطبيق لا يستطيع الاتصال بـ Replit backend.

**الخطأ المعروض**:
```
ERROR MESSAGE: The connection errored: The XMLHttpRequest onError callback was called.
```

---

## 🔍 التشخيص:

### 1. الـ Endpoint الحالي:
```
https://2fbc074f-4ec4-4da4-9211-60501eb8a27a-00-3jpu4qdhzoiii.pike.replit.dev/api/trpc/auth.login
```

### 2. الأسباب المحتملة:

#### ❌ **السبب 1: CORS (Cross-Origin Resource Sharing)**
- الـ backend لا يسمح بطلبات من `localhost` أو من مواقع أخرى
- **الحل**: يجب إضافة CORS headers في الـ backend

#### ❌ **السبب 2: الـ Backend غير شغال**
- Replit قد يكون في وضع Sleep
- **الحل**: فتح الرابط في المتصفح لتشغيله

#### ❌ **السبب 3: Endpoint خاطئ**
- المسار قد يكون مختلف عن المتوقع
- **الحل**: التحقق من الـ backend endpoints

---

## ✅ خطوات الحل:

### الخطوة 1: تحقق من الـ Backend

افتح هذا الرابط في المتصفح:
```
https://2fbc074f-4ec4-4da4-9211-60501eb8a27a-00-3jpu4qdhzoiii.pike.replit.dev
```

**ماذا تتوقع؟**
- إذا ظهرت رسالة أو صفحة = Backend يعمل ✅
- إذا ظهر خطأ 404 or timeout = Backend لا يعمل ❌

---

### الخطوة 2: إصلاح CORS في Backend

يجب إضافة CORS headers في الـ Node.js backend:

```javascript
// في server.js أو index.js
const app = express();

// إضافة CORS
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*'); // أو حدد domain معين
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  
  // Handle preflight requests
  if (req.method === 'OPTIONS') {
    return res.sendStatus(200);
  }
  
  next();
});

// أو استخدم مكتبة cors
const cors = require('cors');
app.use(cors());
```

---

### الخطوة 3: تحقق من tRPC Configuration

إذا كنت تستخدم tRPC، يجب التأكد من:

```javascript
// في tRPC router
import { initTRPC } from '@trpc/server';
import { createHTTPServer } from '@trpc/server/adapters/standalone';

// تأكد من إعداد CORS
createHTTPServer({
  router: appRouter,
  createContext,
  cors: {
    origin: '*', // أو حدد origins معينة
    credentials: true
  }
});
```

---

### الخطوة 4: اختبار الـ API يدوياً

استخدم Postman أو curl لاختبار:

```bash
curl -X POST \
  https://2fbc074f-4ec4-4da4-9211-60501eb8a27a-00-3jpu4qdhzoiii.pike.replit.dev/api/trpc/auth.login \
  -H 'Content-Type: application/json' \
  -d '{"email":"admin@test.com","password":"password"}'
```

**النتائج المتوقعة**:
- ✅ إذا حصلت على response = API يعمل
- ❌ إذا حصلت على CORS error = مشكلة CORS
- ❌ إذا حصلت على timeout = Backend لا يعمل

---

## 🔧 الحلول السريعة:

### حل مؤقت 1: استخدام CORS Proxy
يمكنك استخدام proxy مؤقت:

في `lib/core/constants/app_constants.dart`:
```dart
// استخدام CORS proxy (مؤقت)
static const String baseUrl = 'https://cors-anywhere.herokuapp.com/https://2fbc074f-4ec4-4da4-9211-60501eb8a27a-00-3jpu4qdhzoiii.pike.replit.dev';
```

### حل مؤقت 2: Mock Data
يمكنك اختبار التطبيق بدون API أولاً:

في `lib/data/services/auth_service.dart`:
```dart
Future<Map<String, dynamic>> login(String email, String password) async {
  // Mock response للاختبار
  if (email == "admin@test.com" && password == "123456") {
    return {
      'success': true,
      'token': 'fake-token-123',
      'user': {
        'id': '1',
        'email': email,
        'firstName': 'Admin',
        'lastName': 'User',
        'role': 'admin',
        // ... باقي البيانات
      }
    };
  }
  
  throw Exception('بيانات خاطئة');
}
```

---

## 📋 Checklist للتحقق:

- [ ] الـ Replit backend يعمل (افتح الرابط في المتصفح)
- [ ] CORS مفعّل في Backend
- [ ] الـ endpoints صحيحة `/api/trpc/auth.login`
- [ ] البيانات المرسلة صحيحة (JSON format)
- [ ] الـ Content-Type header مضبوط

---

## 🆘 للمساعدة:

أرسل لي:
1. Screenshot من المتصفح عند فتح رابط Replit
2. كود الـ Backend (خصوصاً CORS configuration)
3. أي رسائل خطأ في console الـ Replit

---

**آخر تحديث**: 8 ديسمبر 2025
