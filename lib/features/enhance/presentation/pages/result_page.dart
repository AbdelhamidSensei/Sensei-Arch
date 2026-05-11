import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../../history/data/models/history_item.dart';
import '../../../history/presentation/providers/history_provider.dart';
import '../providers/enhance_provider.dart';
import '../widgets/before_after_widget.dart';

class ResultPage extends ConsumerWidget {
  final Map<String, String> args;

  const ResultPage({super.key, required this.args});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final originalPath = args['originalPath'] ?? '';
    final resultPath = args['resultPath'] ?? '';
    final state = ref.watch(enhanceStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              Expanded(
                child: BeforeAfterWidget(
                  beforePath: originalPath,
                  afterPath: resultPath,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: AppStrings.save,
                icon: Icons.save_alt,
                onPressed: () async {
                  try {
                    await Gal.putImage(resultPath);
                    if (context.mounted) {
                      context.showSnackBar(AppStrings.savedToGallery);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      context.showSnackBar('Failed to save: $e', isError: true);
                    }
                  }
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              SecondaryButton(
                label: AppStrings.share,
                icon: Icons.share,
                onPressed: () {
                  Share.shareXFiles([XFile(resultPath)]);
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () {
                  // Save to history
                  ref.read(historyListProvider.notifier).add(
                        HistoryItem(
                          id: const Uuid().v4(),
                          originalPath: originalPath,
                          resultPath: resultPath,
                          mode: state.mode.name,
                          createdAt: DateTime.now(),
                        ),
                      );
                  ref.read(enhanceStateProvider.notifier).reset();
                  context.go(Routes.home);
                },
                child: const Text(AppStrings.done),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
