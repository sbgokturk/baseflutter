import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/time_slot_service.dart';

/// Time-based scheduling state
/// st = startTime, et = endTime, t = type, p = package
class TimeSlotState {
  final List<TimeSlot> slots;
  final List<TimeSlot> activeSlots;
  final DateTime? serverTime;
  final int serverTimeHHMM;
  final bool isLoading;
  final String? error;

  const TimeSlotState({
    this.slots = const [],
    this.activeSlots = const [],
    this.serverTime,
    this.serverTimeHHMM = 0,
    this.isLoading = false,
    this.error,
  });

  bool get hasActiveSlots => activeSlots.isNotEmpty;

  /// Server zamanını formatlanmış string olarak döner
  String get serverTimeFormatted {
    if (serverTime == null) return '--:--:--';
    final hour = serverTime!.hour.toString().padLeft(2, '0');
    final minute = serverTime!.minute.toString().padLeft(2, '0');
    final second = serverTime!.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }

  /// Server zamanını HHMM formatında string olarak döner
  String get serverTimeHHMMFormatted {
    final hour = (serverTimeHHMM ~/ 100).toString().padLeft(2, '0');
    final minute = (serverTimeHHMM % 100).toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Belirli bir type'ın aktif olup olmadığını kontrol eder
  bool isTypeActive(String type) {
    return activeSlots.any((slot) => slot.type == type);
  }

  /// Aktif schedule'lardan belirli bir type'ı bulur
  TimeSlot? getActiveSlotByType(String type) {
    try {
      return activeSlots.firstWhere((slot) => slot.type == type);
    } catch (_) {
      return null;
    }
  }

  /// Enabled (start veya end > 0) olan schedule'ları döner
  List<TimeSlot> get enabledSlots {
    return slots.where((slot) => slot.isEnabled).toList();
  }

  TimeSlotState copyWith({
    List<TimeSlot>? slots,
    List<TimeSlot>? activeSlots,
    DateTime? serverTime,
    int? serverTimeHHMM,
    bool? isLoading,
    String? error,
  }) {
    return TimeSlotState(
      slots: slots ?? this.slots,
      activeSlots: activeSlots ?? this.activeSlots,
      serverTime: serverTime ?? this.serverTime,
      serverTimeHHMM: serverTimeHHMM ?? this.serverTimeHHMM,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Time schedule notifier
class TimeSlotNotifier extends Notifier<TimeSlotState> {
  @override
  TimeSlotState build() => const TimeSlotState();

  /// Tüm schedule'ları ve server zamanını yeniler.
  /// Her çağrıda güncel server zamanı çekilir.
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Server zamanını çek
      final serverTime = await TimeSlotService.getServerTime();
      final serverTimeHHMM = await TimeSlotService.getServerTimeHHMM();

      // Tüm schedule'ları çek
      final slots = await TimeSlotService.getAllSlots();
      final activeSlots = slots.where((slot) => slot.isActive).toList();

      state = TimeSlotState(
        slots: slots,
        activeSlots: activeSlots,
        serverTime: serverTime,
        serverTimeHHMM: serverTimeHHMM,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

/// Time Slot Provider
final timeSlotProvider = NotifierProvider<TimeSlotNotifier, TimeSlotState>(
  TimeSlotNotifier.new,
);
