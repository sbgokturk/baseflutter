import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:base/l10n/app_localizations.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../logic/init_logic.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_initialize);
  }

  Future<void> _initialize() async {
    await ref.read(initProvider.notifier).initialize();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final init = ref.watch(initProvider);

    // Navigate when initialized
    ref.listen(initProvider, (previous, next) {
      if (next.isInitialized) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    });

    return Scaffold(
      body: init.error != null
          ? _buildError(init, l10n)
          : _buildLoading(init, l10n),
    );
  }

  Widget _buildLoading(InitState init, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          Icon(Icons.rocket_launch, size: 100, color: AppColors.primary),
          const SizedBox(height: Constants.paddingXL),

          // App name
          Text(
            l10n.appTitle,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: Constants.paddingXL),

          // Loading indicator
          const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(height: Constants.paddingM),

          // Status text
          Text(
            _statusText(l10n, init.status),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildError(InitState init, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Constants.paddingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: AppColors.error),
            const SizedBox(height: Constants.paddingL),

            Text(
              l10n.errorTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: Constants.paddingS),

            Text(
              init.error!,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: Constants.paddingL),

            ElevatedButton.icon(
              onPressed: () => ref.read(initProvider.notifier).retry(),
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }

  String _statusText(AppLocalizations l10n, InitStatus status) {
    switch (status) {
      case InitStatus.starting:
        return l10n.initStarting;
      case InitStatus.connectingFirebase:
        return l10n.initConnectingFirebase;
      case InitStatus.loadingLocalData:
        return l10n.initLoadingLocalData;
      case InitStatus.fetchingRemoteConfig:
        return l10n.initFetchingRemoteConfig;
      case InitStatus.checkingAuthentication:
        return l10n.initCheckingAuthentication;
      case InitStatus.ready:
        return l10n.initReady;
      case InitStatus.retrying:
        return l10n.initRetrying;
    }
  }
}
