import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../providers/enhance_provider.dart';

class ProcessingPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> jobInput;

  const ProcessingPage({super.key, required this.jobInput});

  @override
  ConsumerState<ProcessingPage> createState() => _ProcessingPageState();
}

class _ProcessingPageState extends ConsumerState<ProcessingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(enhanceStateProvider.notifier).startEnhancement();
    });
  }

  String _statusText(String? status) {
    return switch (status) {
      'starting' => AppStrings.uploading,
      'processing' => AppStrings.enhancing,
      'succeeded' => AppStrings.finishing,
      _ => AppStrings.processing,
    };
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(enhanceStateProvider);

    // Navigate to result when done
    ref.listen(enhanceStateProvider, (prev, next) {
      if (next.resultPath != null && !next.isProcessing) {
        context.pushReplacement(Routes.result, extra: {
          'originalPath': next.imagePath ?? '',
          'resultPath': next.resultPath ?? '',
        });
      }
      if (next.error != null && !next.isProcessing) {
        context.showSnackBar(next.error!, isError: true);
        context.pop();
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated processing indicator
                const SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    strokeWidth: 6,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  _statusText(state.currentJob?.status),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Please wait while AI works its magic',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.color
                            ?.withValues(alpha: 0.6),
                      ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                TextButton(
                  onPressed: () {
                    ref.read(enhanceStateProvider.notifier).reset();
                    context.pop();
                  },
                  child: const Text(AppStrings.cancel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
