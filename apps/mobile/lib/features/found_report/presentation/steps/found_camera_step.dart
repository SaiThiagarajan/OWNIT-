import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/buttons/secondary_button.dart';
import '../../models/found_report_draft.dart';

/// Camera-first entry to the Found flow — a photo is required to move on,
/// since the next step's "AI suggestion" is derived from it.
class FoundCameraStep extends StatefulWidget {
  const FoundCameraStep({super.key, required this.draft, required this.onChanged});

  final FoundReportDraft draft;
  final VoidCallback onChanged;

  @override
  State<FoundCameraStep> createState() => _FoundCameraStepState();
}

class _FoundCameraStepState extends State<FoundCameraStep> {
  final _picker = ImagePicker();
  bool _picking = false;

  Future<void> _pick(ImageSource source) async {
    setState(() => _picking = true);
    try {
      final file = await _picker.pickImage(source: source, maxWidth: 1600, imageQuality: 85);
      if (file != null) {
        widget.draft.photoBytes = await file.readAsBytes();
        widget.onChanged();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Couldn't access the camera or photo library.")),
        );
      }
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final photoBytes = widget.draft.photoBytes;
    final hasPhoto = photoBytes != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.s8),
          Text('What did you find?', style: textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.s8),
          Text(
            'Snap a clear photo — our AI will suggest a category and description.',
            style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.s24),
          Container(
            height: 260,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              border: Border.all(color: hasPhoto ? AppColors.foundTeal : AppColors.border),
            ),
            child: hasPhoto
                ? Image.memory(photoBytes, fit: BoxFit.cover)
                : Center(
                    child: _picking
                        ? const CircularProgressIndicator(strokeWidth: 2, color: AppColors.foundTeal)
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.photo_camera_outlined,
                                color: AppColors.foundTeal,
                                size: 40,
                              ),
                              const SizedBox(height: AppSpacing.s12),
                              Text(
                                'No photo yet',
                                style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                  ),
          ),
          const SizedBox(height: AppSpacing.s16),
          PrimaryButton(
            label: hasPhoto ? 'Retake photo' : 'Take photo',
            leadingIcon: Icons.photo_camera_outlined,
            onPressed: _picking ? null : () => _pick(ImageSource.camera),
          ),
          const SizedBox(height: AppSpacing.s12),
          SecondaryButton(
            label: 'Choose from gallery',
            leadingIcon: Icons.photo_library_outlined,
            onPressed: _picking ? null : () => _pick(ImageSource.gallery),
          ),
        ],
      ),
    );
  }
}
