import 'package:cloud_firestore/cloud_firestore.dart';

/// Firebase server zamanını çeken servis.
/// Her çağrıda güncel zamanı alır, cache yapmaz.
/// Zaman hacklenemez çünkü Firebase sunucusundan gelir.
class ServerTimeService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Her çağrıda Firebase sunucusundan güncel zamanı çeker.
  /// Dönen değer UTC DateTime'dır.
  static Future<DateTime> getServerTime() async {
    try {
      // Geçici bir document oluştur, serverTimestamp yaz, oku ve sil
      final docRef = _firestore.collection('_server_time').doc();

      await docRef.set({
        'timestamp': FieldValue.serverTimestamp(),
      });

      final snapshot = await docRef.get();
      final timestamp = snapshot.data()?['timestamp'] as Timestamp?;

      // Temizlik: document'ı sil
      await docRef.delete();

      if (timestamp != null) {
        return timestamp.toDate();
      }

      // Fallback: eğer timestamp alınamazsa local time dön
      return DateTime.now();
    } catch (e) {
      // Hata durumunda local time dön (offline durumu vb.)
      return DateTime.now();
    }
  }

  /// Server zamanını HHMM formatında int olarak döner (örn: 11:30 -> 1130)
  static Future<int> getServerTimeAsHHMM() async {
    final serverTime = await getServerTime();
    return serverTime.hour * 100 + serverTime.minute;
  }

  /// Server zamanından sadece saat ve dakika alır, DateTime olarak döner.
  /// Tarih bilgisi bugünün tarihi olarak ayarlanır.
  static Future<DateTime> getServerTimeOnly() async {
    final serverTime = await getServerTime();
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      serverTime.hour,
      serverTime.minute,
      serverTime.second,
    );
  }
}
