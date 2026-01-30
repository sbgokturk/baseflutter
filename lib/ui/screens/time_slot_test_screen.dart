import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants.dart';
import '../../data/services/time_slot_service.dart';
import '../../l10n/app_localizations.dart';
import '../../logic/providers/time_slot_provider.dart';

/// Time slot mekanizmasını test etmek için ekran.
/// Server zamanı, tüm slotlar ve aktif slotları gösterir.
class TimeSlotTestScreen extends ConsumerStatefulWidget {
  const TimeSlotTestScreen({super.key});

  @override
  ConsumerState<TimeSlotTestScreen> createState() => _TimeSlotTestScreenState();
}

class _TimeSlotTestScreenState extends ConsumerState<TimeSlotTestScreen> {
  @override
  void initState() {
    super.initState();
    // İlk yükleme
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(timeSlotProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(timeSlotProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.timeSlotTestTitle),
        actions: [
          IconButton(
            icon: state.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
            onPressed: state.isLoading
                ? null
                : () => ref.read(timeSlotProvider.notifier).refresh(),
            tooltip: l10n.timeSlotRefresh,
          ),
        ],
      ),
      body: state.isLoading && state.slots.isEmpty
          ? Center(child: Text(l10n.timeSlotLoading))
          : state.error != null && state.slots.isEmpty
              ? Center(child: Text(l10n.timeSlotError(state.error!)))
              : RefreshIndicator(
                  onRefresh: () => ref.read(timeSlotProvider.notifier).refresh(),
                  child: ListView(
                    padding: const EdgeInsets.all(Constants.paddingM),
                    children: [
                      // Server Time Card
                      _buildServerTimeCard(context, l10n, state),

                      const SizedBox(height: Constants.paddingM),

                      // Active Slots Section
                      _buildSectionTitle(l10n.timeSlotActiveSlots),
                      const SizedBox(height: Constants.paddingS),
                      if (state.activeSlots.isEmpty)
                        _buildNoActiveSlotsCard(l10n)
                      else
                        ...state.activeSlots.map(
                          (slot) => _buildSlotCard(context, l10n, slot, true),
                        ),

                      const SizedBox(height: Constants.paddingL),

                      // All Slots Section
                      _buildSectionTitle(l10n.timeSlotAllSlots),
                      const SizedBox(height: Constants.paddingS),
                      ...state.slots.map(
                        (slot) => _buildSlotCard(context, l10n, slot, false),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildServerTimeCard(
    BuildContext context,
    AppLocalizations l10n,
    TimeSlotState state,
  ) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Constants.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.access_time, size: 20),
                const SizedBox(width: Constants.paddingS),
                Text(
                  l10n.timeSlotServerTime,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Constants.paddingM),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.serverTimeFormatted,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: Constants.paddingXS),
                    Text(
                      '${l10n.timeSlotCurrentTime}: ${state.serverTimeHHMM}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                if (state.isLoading)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildNoActiveSlotsCard(AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Constants.paddingM),
        child: Row(
          children: [
            const Icon(Icons.info_outline),
            const SizedBox(width: Constants.paddingS),
            Text(l10n.timeSlotNoActiveSlots),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotCard(
    BuildContext context,
    AppLocalizations l10n,
    TimeSlot slot,
    bool highlightActive,
  ) {
    final theme = Theme.of(context);
    final isDisabled = !slot.isEnabled;
    final n = slot.scheduleNumber;

    Color? cardColor;
    if (highlightActive && slot.isActive) {
      cardColor = theme.colorScheme.primaryContainer;
    } else if (isDisabled) {
      cardColor = theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);
    }

    return Card(
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(Constants.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.timeSlotSlotNumber(slot.scheduleNumber),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDisabled
                        ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                        : null,
                  ),
                ),
                _buildStatusChip(context, l10n, slot),
              ],
            ),

            if (!isDisabled) ...[
              const SizedBox(height: Constants.paddingS),

              // Time Row
              Row(
                children: [
                  _buildInfoItem(
                    context,
                    l10n.timeSlotStartTime,
                    slot.startTimeFormatted,
                    Icons.play_arrow,
                  ),
                  const SizedBox(width: Constants.paddingL),
                  _buildInfoItem(
                    context,
                    l10n.timeSlotEndTime,
                    slot.endTimeFormatted,
                    Icons.stop,
                  ),
                ],
              ),

              const SizedBox(height: Constants.paddingS),

              // Type & Package Row
              Row(
                children: [
                  _buildInfoItem(
                    context,
                    l10n.timeSlotType,
                    slot.type.isEmpty ? '-' : slot.type,
                    Icons.category,
                  ),
                  const SizedBox(width: Constants.paddingL),
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      l10n.timeSlotPackage,
                      slot.package.isEmpty ? '-' : slot.package,
                      Icons.inventory_2,
                    ),
                  ),
                ],
              ),
            ],

            // Remote Keys Section
            const SizedBox(height: Constants.paddingS),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Constants.paddingS),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(Constants.radiusS),
              ),
              child: Text(
                'st$n: ${slot.startTime} | et$n: ${slot.endTime} | st${n}t: ${slot.type.isEmpty ? '""' : '"${slot.type}"'} | st${n}p: ${slot.package.isEmpty ? '""' : '"${slot.package}"'}',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(
    BuildContext context,
    AppLocalizations l10n,
    TimeSlot slot,
  ) {
    final theme = Theme.of(context);

    if (!slot.isEnabled) {
      return Chip(
        label: Text(
          l10n.timeSlotDisabled,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
      );
    }

    if (slot.isActive) {
      return Chip(
        label: Text(
          l10n.timeSlotActive,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
      );
    }

    return Chip(
      label: Text(
        l10n.timeSlotInactive,
        style: TextStyle(
          fontSize: 12,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
