import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class BookingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// هذه الدالة تقوم بحجز الموعد باستخدام نظام [Firestore Transactions]
  /// مما يضمن أنه لو حاول 10 أشخاص حجز نفس الوقت في نفس الثانية،
  /// سيحصل عليه شخص واحد فقط، ويفشل البقية! (منع التضارب - Concurrency Control)
  Future<bool> bookTimeSlotConcurrently({
    required String barberId,
    required String date, // مثال: '2024-03-20'
    required String timeText, // مثال: '10:30 ص'
    required String customerId,
    required String customerName,
  }) async {
    // 1. تحديد المرجع الدقيق للوقت المطلوب في قاعدة البيانات
    // المسار: Barbers -> [barberId] -> Schedules -> [date] -> Slots -> [timeText]
    final slotRef = _db
        .collection('barbers')
        .doc(barberId)
        .collection('schedules')
        .doc(date)
        .collection('slots')
        .doc(timeText);

    try {
      // 2. تشغيل العملية في إطار Transaction (معاملة ذرية آمنة)
      return await _db.runTransaction((transaction) async {
        // - قراءة البيانات الحالية للموعد داخل الـ Transaction
        final snapshot = await transaction.get(slotRef);

        if (!snapshot.exists) {
          // الموعد غير موجود في الداتابيز إطلاقاً (إذن هو متاح ونحن أول من يحجزه)
          transaction.set(slotRef, {
            'isBooked': true,
            'customerId': customerId,
            'customerName': customerName,
            'timestamp': FieldValue.serverTimestamp(),
          });
          return true; // تمت العملية بنجاح!
        }

        // - الموعد موجود مسبقاً، لذا نتأكد إن كان محجوزاً
        final data = snapshot.data()!;
        final bool isBooked = data['isBooked'] ?? false;

        if (isBooked) {
          // ⚠️ نظام منع التضارب (Concurrency Prevented):
          // لقد قام شخص آخر بخطف الموعد للتو! نرفض الحجز فوراً.
          return false;
        } else {
          // ✅ الموعد متاح ولم يُسبقنا إليه أحد، نقوم بتسجيله فوراً
          transaction.update(slotRef, {
            'isBooked': true,
            'customerId': customerId,
            'customerName': customerName,
            'updatedAt': FieldValue.serverTimestamp(),
          });
          return true; // تمت العملية بنجاح!
        }
      });
    } catch (e) {
      // في حال وجود مشكلة في الاتصال بالإنترنت
      debugPrint('Booking Transaction failed: $e');
      return false;
    }
  }
}
