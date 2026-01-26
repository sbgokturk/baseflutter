import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/firebase_service.dart';
import '../data/services/storage_service.dart';
import '../data/services/remote_config_service.dart';
import '../data/services/auth_service.dart';
import 'providers/providers.dart';

/// Init state
class InitState {
  final bool isInitialized;
  final String status;
  final String? error;

  InitState({
    this.isInitialized = false,
    this.status = 'Starting...',
    this.error,
  });

  InitState copyWith({bool? isInitialized, String? status, String? error}) {
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

  /// Initialize all services
  Future<void> initialize() async {
    try {
      // Firebase
      _updateStatus('Connecting to Firebase...');
      await FirebaseService.init();

      // Local Storage
      _updateStatus('Loading local data...');
      await StorageService.init();

      // Remote Config
      _updateStatus('Fetching remote config...');
      await RemoteConfigService.init();
      _ref.read(remoteConfigProvider.notifier).load();

      // Auth check
      _updateStatus('Checking authentication...');
      final authService = AuthService();
      if (!authService.isLoggedIn) {
        await authService.signInAnonymously();
      }
      _ref.read(authProvider.notifier).checkAuth();

      // Ready
      _updateStatus('Ready!');
      await Future.delayed(const Duration(milliseconds: 300));

      state = state.copyWith(isInitialized: true);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void _updateStatus(String status) {
    state = state.copyWith(status: status);
  }

  /// Retry initialization
  Future<void> retry() async {
    state = InitState(status: 'Retrying...');
    await initialize();
  }
}

/// Init Provider
final initProvider = StateNotifierProvider<InitNotifier, InitState>((ref) {
  return InitNotifier(ref);
});
