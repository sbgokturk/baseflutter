import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants.dart';
import '../../logic/providers/providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(remoteConfigProvider);
    final auth = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Base'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Constants.paddingM),
        child: Column(
          children: [
            Icon(
              Icons.rocket_launch,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: Constants.paddingL),
            Text(
              'Welcome to Base',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: Constants.paddingS),
            Text('User ID: ${auth.userId ?? 'Not logged in'}'),
            const SizedBox(height: Constants.paddingL),

            // Remote Config değerleri
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Constants.paddingM),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(Constants.radiusM),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Remote Config',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: Constants.paddingM),
                  
                  // Direkt kullanım örnekleri
                  _row('appInReview', config.appInReview.toString()),
                  _row('forceUpdate', config.forceUpdate.toString()),
                  _row('maintenanceMode', config.maintenanceMode.toString()),
                  _row('adEnabled', config.adEnabled.toString()),
                  _row('showAds', config.showAds.toString()),
                  _row('minVersion', config.minVersion),
                  _row('privacyUrl', config.privacyUrl),
                  _row('termsUrl', config.termsUrl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(key, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
