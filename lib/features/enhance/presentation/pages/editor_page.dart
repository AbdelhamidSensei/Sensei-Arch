import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/enhance_provider.dart';
import '../widgets/image_preview.dart';
import '../widgets/mode_selector.dart';

class EditorPage extends ConsumerWidget {
  final String imagePath;

  const EditorPage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(enhanceStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Photo')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: ImagePreview(imagePath: imagePath),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ModeSelector(
                selected: state.mode,
                onChanged: (mode) =>
                    ref.read(enhanceStateProvider.notifier).setMode(mode),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Enhance',
                icon: Icons.auto_awesome,
                onPressed: () {
                  context.push(Routes.processing, extra: {
                    'imagePath': imagePath,
                    'mode': state.mode.name,
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
