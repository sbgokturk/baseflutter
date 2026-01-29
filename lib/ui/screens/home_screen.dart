import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:base/l10n/app_localizations.dart';
import '../../core/constants.dart';
import '../../logic/providers/providers.dart';

enum _LocaleChoice { system, en, tr }

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final config = ref.watch(remoteConfigProvider);
    final auth = ref.watch(authProvider);
    final locale = ref.watch(localeProvider);
    final userIdText = auth.userId == null
        ? l10n.notLoggedIn
        : l10n.userIdLabel(auth.userId!);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          PopupMenuButton<_LocaleChoice>(
            tooltip: l10n.language,
            initialValue: locale == null
                ? _LocaleChoice.system
                : (locale.languageCode == 'tr'
                      ? _LocaleChoice.tr
                      : _LocaleChoice.en),
            onSelected: (value) {
              final notifier = ref.read(localeProvider.notifier);
              switch (value) {
                case _LocaleChoice.system:
                  notifier.useSystem();
                  break;
                case _LocaleChoice.en:
                  notifier.setEnglish();
                  break;
                case _LocaleChoice.tr:
                  notifier.setTurkish();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _LocaleChoice.system,
                child: Text(l10n.systemLanguage),
              ),
              PopupMenuItem(value: _LocaleChoice.en, child: Text(l10n.english)),
              PopupMenuItem(value: _LocaleChoice.tr, child: Text(l10n.turkish)),
            ],
            icon: const Icon(Icons.language),
          ),
        ],
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
              l10n.welcomeMessage,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: Constants.paddingS),
            Text(userIdText),
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
                    l10n.remoteConfigTitle,
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
            child: Text(
              key,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
