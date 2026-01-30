import '../../config/remote_keys.dart';
import 'remote_config_service.dart';
import 'server_time_service.dart';

/// Tek bir schedule'ın bilgilerini tutan model
/// st1=startTime1, et1=endTime1, st1t=startTime1Type, st1p=startTime1Package
class TimeSlot {
  final int scheduleNumber;
  final int startTime; // HHMM format (örn: 1100 = 11:00)
  final int endTime; // HHMM format (örn: 1200 = 12:00)
  final String type; // startTimeNType
  final String package; // startTimeNPackage
  final bool isActive;

  const TimeSlot({
    required this.scheduleNumber,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.package,
    required this.isActive,
  });

  /// Schedule'ın enabled olup olmadığını kontrol eder (0 değilse enabled)
  bool get isEnabled => startTime != 0 || endTime != 0;

  /// Başlangıç zamanını HH:MM formatında string olarak döner
  String get startTimeFormatted {
    final hour = (startTime ~/ 100).toString().padLeft(2, '0');
    final minute = (startTime % 100).toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Bitiş zamanını HH:MM formatında string olarak döner
  String get endTimeFormatted {
    final hour = (endTime ~/ 100).toString().padLeft(2, '0');
    final minute = (endTime % 100).toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  String toString() {
    return 'Schedule($scheduleNumber: $startTimeFormatted-$endTimeFormatted, type: $type, package: $package, active: $isActive)';
  }
}

/// Time slot'ları yöneten servis.
/// Remote config'den değerleri okur ve server zamanına göre aktif slot'ları belirler.
class TimeSlotService {
  /// Verilen HHMM değerinin geçerli bir saat olup olmadığını kontrol eder
  static bool _isValidTime(int hhmm) {
    final hour = hhmm ~/ 100;
    final minute = hhmm % 100;
    return hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59;
  }

  /// Verilen zaman (currentHHMM) start ve end arasında mı kontrol eder.
  /// Gece geçişini de destekler (örn: 2300-0600)
  static bool _isTimeInRange(int currentHHMM, int startHHMM, int endHHMM) {
    // Geçersiz değerler için false dön
    if (!_isValidTime(currentHHMM) ||
        !_isValidTime(startHHMM) ||
        !_isValidTime(endHHMM)) {
      return false;
    }

    // Slot disabled ise (ikisi de 0)
    if (startHHMM == 0 && endHHMM == 0) {
      return false;
    }

    // Normal aralık (örn: 1100-1200)
    if (startHHMM <= endHHMM) {
      return currentHHMM >= startHHMM && currentHHMM < endHHMM;
    }

    // Gece geçişi (örn: 2300-0600)
    // Ya şu anki zaman >= başlangıç (gece yarısından önce)
    // Ya da şu anki zaman < bitiş (gece yarısından sonra)
    return currentHHMM >= startHHMM || currentHHMM < endHHMM;
  }

  /// Remote config'den belirli bir schedule'ın değerlerini okur
  static TimeSlot _getScheduleFromConfig(int scheduleNumber, int currentTimeHHMM) {
    late String startKey, endKey, typeKey, packageKey;

    switch (scheduleNumber) {
      case 1:
        startKey = RemoteKeys.startTime1;
        endKey = RemoteKeys.endTime1;
        typeKey = RemoteKeys.startTime1Type;
        packageKey = RemoteKeys.startTime1Package;
        break;
      case 2:
        startKey = RemoteKeys.startTime2;
        endKey = RemoteKeys.endTime2;
        typeKey = RemoteKeys.startTime2Type;
        packageKey = RemoteKeys.startTime2Package;
        break;
      case 3:
        startKey = RemoteKeys.startTime3;
        endKey = RemoteKeys.endTime3;
        typeKey = RemoteKeys.startTime3Type;
        packageKey = RemoteKeys.startTime3Package;
        break;
      case 4:
        startKey = RemoteKeys.startTime4;
        endKey = RemoteKeys.endTime4;
        typeKey = RemoteKeys.startTime4Type;
        packageKey = RemoteKeys.startTime4Package;
        break;
      case 5:
        startKey = RemoteKeys.startTime5;
        endKey = RemoteKeys.endTime5;
        typeKey = RemoteKeys.startTime5Type;
        packageKey = RemoteKeys.startTime5Package;
        break;
      case 6:
        startKey = RemoteKeys.startTime6;
        endKey = RemoteKeys.endTime6;
        typeKey = RemoteKeys.startTime6Type;
        packageKey = RemoteKeys.startTime6Package;
        break;
      case 7:
        startKey = RemoteKeys.startTime7;
        endKey = RemoteKeys.endTime7;
        typeKey = RemoteKeys.startTime7Type;
        packageKey = RemoteKeys.startTime7Package;
        break;
      case 8:
        startKey = RemoteKeys.startTime8;
        endKey = RemoteKeys.endTime8;
        typeKey = RemoteKeys.startTime8Type;
        packageKey = RemoteKeys.startTime8Package;
        break;
      case 9:
        startKey = RemoteKeys.startTime9;
        endKey = RemoteKeys.endTime9;
        typeKey = RemoteKeys.startTime9Type;
        packageKey = RemoteKeys.startTime9Package;
        break;
      default:
        return TimeSlot(
          scheduleNumber: scheduleNumber,
          startTime: 0,
          endTime: 0,
          type: '',
          package: '',
          isActive: false,
        );
    }

    final startTime = RemoteConfigService.getInt(startKey);
    final endTime = RemoteConfigService.getInt(endKey);
    final type = RemoteConfigService.getString(typeKey);
    final package = RemoteConfigService.getString(packageKey);

    final isActive = _isTimeInRange(currentTimeHHMM, startTime, endTime);

    return TimeSlot(
      scheduleNumber: scheduleNumber,
      startTime: startTime,
      endTime: endTime,
      type: type,
      package: package,
      isActive: isActive,
    );
  }

  /// Tüm schedule'ları (1-9) remote config'den okur ve server zamanına göre durumlarını belirler.
  /// Her çağrıda güncel server zamanını çeker.
  static Future<List<TimeSlot>> getAllSchedules() async {
    final currentTimeHHMM = await ServerTimeService.getServerTimeAsHHMM();
    return getAllSchedulesWithTime(currentTimeHHMM);
  }

  /// Tüm schedule'ları verilen zaman ile kontrol eder (test için kullanışlı)
  static List<TimeSlot> getAllSchedulesWithTime(int currentTimeHHMM) {
    return List.generate(
      9,
      (index) => _getScheduleFromConfig(index + 1, currentTimeHHMM),
    );
  }

  /// Şu an aktif olan schedule'ları döner
  static Future<List<TimeSlot>> getActiveSchedules() async {
    final allSchedules = await getAllSchedules();
    return allSchedules.where((schedule) => schedule.isActive).toList();
  }

  /// Belirli bir schedule numarasının bilgilerini döner
  static Future<TimeSlot> getSchedule(int scheduleNumber) async {
    final currentTimeHHMM = await ServerTimeService.getServerTimeAsHHMM();
    return _getScheduleFromConfig(scheduleNumber, currentTimeHHMM);
  }

  /// Belirli bir type'ın aktif olup olmadığını kontrol eder
  static Future<bool> isTypeActive(String type) async {
    final activeSchedules = await getActiveSchedules();
    return activeSchedules.any((schedule) => schedule.type == type);
  }

  /// Aktif schedule'lardan belirli bir type'ı bulur ve döner
  static Future<TimeSlot?> getActiveScheduleByType(String type) async {
    final activeSchedules = await getActiveSchedules();
    try {
      return activeSchedules.firstWhere((schedule) => schedule.type == type);
    } catch (_) {
      return null;
    }
  }

  /// Server zamanını güncel olarak çeker ve döner
  static Future<DateTime> getServerTime() async {
    return ServerTimeService.getServerTime();
  }

  /// Server zamanını HHMM formatında döner
  static Future<int> getServerTimeHHMM() async {
    return ServerTimeService.getServerTimeAsHHMM();
  }

  // ==================== LEGACY ALIASES (backward compatibility) ====================
  static Future<List<TimeSlot>> getAllSlots() => getAllSchedules();
  static List<TimeSlot> getAllSlotsWithTime(int currentTimeHHMM) =>
      getAllSchedulesWithTime(currentTimeHHMM);
  static Future<List<TimeSlot>> getActiveSlots() => getActiveSchedules();
  static Future<TimeSlot> getSlot(int slotNumber) => getSchedule(slotNumber);
}
