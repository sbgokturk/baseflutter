import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/firebase_service.dart';
import '../data/services/storage_service.dart';
import '../data/services/remote_config_service.dart';
import '../data/services/auth_service.dart';
import '../data/services/user_service.dart';
import '../data/services/revenuecat_service.dart';
import '../data/services/analytics_service.dart';
import 'providers/providers.dart';

enum InitStatus {
  starting,
  connectingFirebase,
  loadingLocalData,
  fetchingRemoteConfig,
  loadingTimeSlots,
  checkingAuthentication,
  ready,
  retrying,
}

/// Init state
class InitState {
  final bool isInitialized;
  final InitStatus status;
  final String? error;

  InitState({
    this.isInitialized = false,
    this.status = InitStatus.starting,
    this.error,
  });

  InitState copyWith({bool? isInitialized, InitStatus? status, String? error}) {
    return InitState(
      isInitialized: isInitialized ?? this.isInitialized,
      status: status ?? this.status,
      error: error,
    );
  }
}

/// Init Notifier
class InitNotifier extends StateNotifier<InitState> {
  final Ref _ref;

  InitNotifier(this._ref) : super(InitState());

  /// Initialize all services.
  /// Order: Firebase → Auth → RevenueCat → Analytics (her biri bir sonrakine bağımlı).
  Future<void> initialize() async {
    try {
      // 1. Firebase (main'de zaten yapıldı, burada no-op)
      _updateStatus(InitStatus.connectingFirebase);
      await FirebaseService.init();

      // 2. Auth (uid lazım: RevenueCat + Analytics)
      _updateStatus(InitStatus.checkingAuthentication);
      final authService = AuthService();
      if (!authService.isLoggedIn) {
        await authService.signInAnonymously();
      }
      final uid = authService.userId;
      _ref.read(authProvider.notifier).checkAuth();

      // 3. User doc + RevenueCat (uid ile)
      if (uid != null) {
        await UserService().ensureUserDocument(uid);
        await RevenueCatService.configure(uid);
      }

      // 4. Analytics (user context ile en sonda)
      if (uid != null) {
        AnalyticsService().updateUserData(userId: uid);
      }
      await AnalyticsService().initialize();

      // Paralel bağımsız servisler (uid gerektirmez)
      _updateStatus(InitStatus.loadingLocalData);
      await StorageService.init();

      // Remote Config yükle
      _updateStatus(InitStatus.fetchingRemoteConfig);
      await RemoteConfigService.init();
      _ref.read(remoteConfigProvider.notifier).load();

      // Time Slot'ları yükle (Remote Config'e bağımlı)
      _updateStatus(InitStatus.loadingTimeSlots);
      await _ref.read(timeSlotProvider.notifier).refresh();

      // Ready
      _updateStatus(InitStatus.ready);
      await Future.delayed(const Duration(milliseconds: 300));

      state = state.copyWith(isInitialized: true);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void _updateStatus(InitStatus status) {
    state = state.copyWith(status: status);
  }

  /// Retry initialization
  Future<void> retry() async {
    state = InitState(status: InitStatus.retrying);
    await initialize();
  }
}

/// Init Provider
final initProvider = StateNotifierProvider<InitNotifier, InitState>((ref) {
  return InitNotifier(ref);
});
