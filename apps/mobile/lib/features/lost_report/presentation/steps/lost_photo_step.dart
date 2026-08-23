import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../models/lost_report_draft.dart';

/// Photo is optional here — this step never blocks Continue on having one.
class LostPhotoStep extends StatefulWidget {
  const LostPhotoStep({super.key, required this.draft, required this.onChanged});

  final LostReportDraft draft;
  final VoidCallback onChanged;

  @override
  State<LostPhotoStep> createState() => _LostPhotoStepState();
}

class _LostPhotoStepState extends State<LostPhotoStep> {
  final _picker = ImagePicker();
  bool _picking = false;

  Future<void> _pick(ImageSource source) async {
    setState(() => _picking = true);
    try {
      final file = await _picker.pickImage(source: source, maxWidth: 1600, imageQuality: 85);
      if (file != null) {
        final bytes = await file.readAsBytes();
        widget.draft.photoBytes = bytes;
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

  void _remove() {
    widget.draft.photoBytes = null;
    widget.onChanged();
    setState(() {});
  }

  void _showSourceSheet() {
    AppBottomSheet.show(
      context: context,
      title: 'Add a photo',
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.photo_camera_outlined, color: AppColors.textPrimary),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.of(context).pop();
                _pick(ImageSource.camera);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.photo_library_outlined, color: AppColors.textPrimary),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _pick(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
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
          Text('What did it look like?', style: textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.s8),
          Text(
            'A photo helps our AI match your report faster — it\'s optional.',
            style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.s24),
          Semantics(
            button: true,
            label: hasPhoto ? 'Photo added. Tap to replace.' : 'Add a photo',
            child: GestureDetector(
              onTap: _picking ? null : _showSourceSheet,
              child: Container(
                height: 200,
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                  border: Border.all(color: AppColors.border),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (hasPhoto)
                      Image.memory(photoBytes, fit: BoxFit.cover)
                    else
                      Center(
                        child: _picking
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.add_a_photo_outlined,
                                    color: AppColors.textSecondary,
                                    size: 28,
                                  ),
                                  const SizedBox(height: AppSpacing.s8),
                                  Text(
                                    'Add a photo',
                                    style: textTheme.labelLarge?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    if (hasPhoto)
                      Positioned(
                        top: AppSpacing.s8,
                        right: AppSpacing.s8,
                        child: Semantics(
                          button: true,
                          label: 'Remove photo',
                          child: InkWell(
                            onTap: _remove,
                            borderRadius: BorderRadius.circular(999),
                            child: Container(
                              padding: const EdgeInsets.all(AppSpacing.s8),
                              decoration: BoxDecoration(
                                color: AppColors.background.withValues(alpha: 0.7),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, color: AppColors.textPrimary, size: 16),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
