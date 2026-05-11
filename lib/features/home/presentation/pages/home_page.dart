import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/image_utils.dart';
import '../../../enhance/domain/entities/enhancement_job.dart';
import '../../../enhance/presentation/providers/enhance_provider.dart';
import '../../providers/home_provider.dart';
import '../widgets/feature_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  Future<void> _pickAndNavigate(
    BuildContext context,
    WidgetRef ref,
    EnhancementMode mode,
  ) async {
    final hasPermission = await ImageUtils.requestPhotoPermission();
    if (!hasPermission) {
      if (context.mounted) await ImageUtils.showPermissionDeniedDialog(context);
      return;
    }

    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    ref.read(enhanceStateProvider.notifier)
      ..reset()
      ..setImage(file.path)
      ..setMode(mode);

    if (context.mounted) context.push(Routes.editor, extra: file.path);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recent = ref.watch(recentEnhancementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push(Routes.history),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(Routes.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: AppColors.brandGradient,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              ),
              child: Column(
                children: [
                  const Icon(Icons.auto_awesome, size: 48, color: Colors.white),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    AppStrings.heroTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    AppStrings.tagline,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white70,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Feature cards
            FeatureCard(
              title: AppStrings.enhance,
              subtitle: '2-4x upscale with Real-ESRGAN',
              icon: Icons.photo_size_select_large,
              onTap: () =>
                  _pickAndNavigate(context, ref, EnhancementMode.enhance),
            ),
            const SizedBox(height: AppSpacing.sm),
            FeatureCard(
              title: AppStrings.restoreFace,
              subtitle: 'Revive old & blurry faces',
              icon: Icons.face_retouching_natural,
              onTap: () =>
                  _pickAndNavigate(context, ref, EnhancementMode.restoreFace),
            ),
            const SizedBox(height: AppSpacing.sm),
            FeatureCard(
              title: AppStrings.colorize,
              subtitle: 'Bring B&W photos to life',
              icon: Icons.color_lens,
              onTap: () =>
                  _pickAndNavigate(context, ref, EnhancementMode.colorize),
            ),
            const SizedBox(height: AppSpacing.sm),
            FeatureCard(
              title: 'Remove Watermark',
              subtitle: 'Clean up watermarks & text',
              icon: Icons.cleaning_services,
              onTap: () =>
                  _pickAndNavigate(context, ref, EnhancementMode.removeWatermark),
            ),
            const SizedBox(height: AppSpacing.sm),
            FeatureCard(
              title: 'Remove Background',
              subtitle: 'Instant background removal',
              icon: Icons.content_cut,
              onTap: () =>
                  _pickAndNavigate(context, ref, EnhancementMode.removeBackground),
            ),

            // Recent enhancements
            if (recent.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                AppStrings.recentEnhancements,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: recent.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final item = recent[index];
                    return GestureDetector(
                      onTap: () => context.push(Routes.result, extra: {
                        'originalPath': item.originalPath,
                        'resultPath': item.resultPath,
                      }),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                        child: Image.file(
                          File(item.resultPath),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
