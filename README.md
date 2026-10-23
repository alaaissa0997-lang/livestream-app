# تطبيق Flutter للبث المباشر (مع ZEGOCLOUD)

## الإعداد
1. `flutter create livestream_app` ثم انسخ `lib/` و`pubspec.yaml` فوق المشروع، ثم `flutter pub get`
   (إن اختلفت إصدارات الحزم: `flutter pub upgrade --major-versions`)
2. شغّل:  `flutter run --dart-define=API_URL=http://10.0.2.2:3000`  (محاكي أندرويد)

## مفاتيح ZEGOCLOUD: أين توضع؟
**لا تضع أي مفتاح داخل تطبيق Flutter.** السيرفر يرجع `appId` والتوكن لكل غرفة عبر `POST /api/streams/:id/zego-token`.
- `AppID` و`ServerSecret` → في ملف `.env` على السيرفر (`ZEGO_APP_ID`, `ZEGO_SERVER_SECRET`).
- `AppSign` → غير مطلوب. وجوده في التطبيق يُفعّل مصادقة AppSign (يُتحقق منه أولاً) فيفقد التوكن قيمته الأمنية.
  للاختبار السريع فقط: `--dart-define=ZEGO_APP_SIGN=...`

## إعدادات المنصات (راجع وثيقة تثبيت ZEGO Express لقائمة الأذونات الكاملة)
- **أندرويد** `AndroidManifest.xml`: `INTERNET`, `ACCESS_NETWORK_STATE`, `CAMERA`, `RECORD_AUDIO`, `MODIFY_AUDIO_SETTINGS`
  (+ `android:usesCleartextTraffic="true"` للتطوير على HTTP فقط) • `minSdkVersion 23`
- **iOS** `Info.plist`: `NSCameraUsageDescription` و`NSMicrophoneUsageDescription`،
  وفي `Podfile` (post_install) فعّل `PERMISSION_CAMERA=1` و`PERMISSION_MICROPHONE=1` لحزمة permission_handler.

## الهيكل
- `services/zego_service.dart`  دخول غرفة ZEGO بالتوكن، نشر/تشغيل الستريم، تجديد التوكن تلقائياً
- `services/realtime_service.dart`  Socket.IO: دردشة، هدايا، مشاهدون، ترتيب
- `screens/room_screen.dart` (مشاهد) و`screens/broadcast_screen.dart` (مذيع: ميكروفون/كاميرا/قلب)

---

## الإصدار 3 من الواجهة: خدمة العملاء والآدمن والاقتصاد
- **واتساب خدمة العملاء (الرقم الوحيد 0997421494):** `widgets/support_button.dart` (يفتح `wa.me/963997421494`).
  يظهر في: شاشة الدخول، الشاشة الرئيسية، المحفظة وصفحة الشحن (برسالة جاهزة بالباقة واسم المستخدم)، وإعداد البث للمذيعين.
- **الشحن:** اختيار الباقة يفتح واتساب برسالة جاهزة؛ والآدمن يضيف الكوينز بعد الدفع من لوحة التحكم (تبويب "شحن كوينز").
- **لوحة التحكم:** تظهر أيقونتها لحساب الآدمن فقط (السيرفر يتحقق من الدور في كل طلب): طلبات السحب (تم الدفع/رفض)، الشحن اليدوي، أرباح الإدارة، وتغيير كلمة المرور.
- **المحفظة:** شرط الدعم خلال 5 أيام، المكافآت المعلّقة، الحد الأدنى للسحب (100,000 نقطة = 10$)، ورسوم 1.5$ لكل سحب.
- أضف حزمة `url_launcher` (موجودة في pubspec) ولا يلزم إعداد إضافي لروابط https.

---

## الإصدار 4 من الواجهة: التأكد من البث الفعلي
- ردّ النبضة من السيرفر يتضمن `publishing`؛ إن كان `false` (ZEGO لا يرى بثاً) يظهر للمذيع تنبيه أحمر ويتوقف الوقت والمكافآت.
- إن لم يصل البث خلال مهلة السماح (60 ثانية افتراضياً) يُنهي السيرفر الجلسة (`no_stream`) ويظهر للمشاهدين والمذيع "توقّف نشر الفيديو".
- لا تغيير مطلوب في إعداد ZEGO داخل التطبيق: الإشعارات تذهب من ZEGO إلى السيرفر مباشرة (انظر README السيرفر).
