import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../utils/friendly_date.dart';
import 'inputs/app_text_field.dart';

/// Coarse location + approximate date/time picker, shared by the Lost and
/// Found report flows. Only ever collects a free-text approximate area —
/// never exact coordinates — so there is nothing precise to leak.
class LocationDateTimeStep extends StatefulWidget {
  const LocationDateTimeStep({
    super.key,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.initialLocation,
    required this.initialDateTime,
    required this.onLocationChanged,
    required this.onDateTimeChanged,
  });

  final String title;
  final String subtitle;
  final Color accentColor;
  final String? initialLocation;
  final DateTime? initialDateTime;
  final ValueChanged<String> onLocationChanged;
  final ValueChanged<DateTime> onDateTimeChanged;

  @override
  State<LocationDateTimeStep> createState() => _LocationDateTimeStepState();
}

class _LocationDateTimeStepState extends State<LocationDateTimeStep> {
  late final TextEditingController _locationController;
  DateTime? _dateTime;

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController(text: widget.initialLocation ?? '');
    _dateTime = widget.initialDateTime;
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = _dateTime ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now,
    );
    if (picked == null) return;
    final existing = _dateTime ?? now;
    final updated = DateTime(picked.year, picked.month, picked.day, existing.hour, existing.minute);
    setState(() => _dateTime = updated);
    widget.onDateTimeChanged(updated);
  }

  Future<void> _pickTime() async {
    final now = DateTime.now();
    final existing = _dateTime ?? now;
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(existing));
    if (picked == null) return;
    final updated = DateTime(existing.year, existing.month, existing.day, picked.hour, picked.minute);
    setState(() => _dateTime = updated);
    widget.onDateTimeChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dateTime = _dateTime;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.s8),
          Text(widget.title, style: textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.s8),
          Text(widget.subtitle, style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.s24),
          Container(
            height: 96,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              border: Border.all(color: AppColors.border),
            ),
            child: Center(
              child: Icon(Icons.location_on_outlined, color: widget.accentColor, size: 32),
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          AppTextField(
            label: 'Approximate area or landmark',
            hintText: 'e.g. Near Central Library',
            controller: _locationController,
            onChanged: widget.onLocationChanged,
          ),
          const SizedBox(height: AppSpacing.s24),
          Row(
            children: [
              Expanded(
                child: _PickerField(
                  label: 'Date',
                  value: dateTime == null ? 'Select date' : friendlyDate(dateTime),
                  icon: Icons.calendar_today_outlined,
                  onTap: _pickDate,
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: _PickerField(
                  label: 'Time',
                  value: dateTime == null ? 'Select time' : TimeOfDay.fromDateTime(dateTime).format(context),
                  icon: Icons.access_time_outlined,
                  onTap: _pickTime,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelMedium?.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.s8),
        Semantics(
          button: true,
          label: '$label, $value',
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
            child: Container(
              height: AppSpacing.controlHeight,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: AppColors.textSecondary),
                  const SizedBox(width: AppSpacing.s8),
                  Expanded(
                    child: Text(
                      value,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
