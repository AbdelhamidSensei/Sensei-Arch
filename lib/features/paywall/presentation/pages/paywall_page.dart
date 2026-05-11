import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/primary_button.dart';

class PaywallPage extends ConsumerWidget {
  const PaywallPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pro Plans')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Text(
              'Unlock Unlimited Enhancements',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            const _PlanTile(
              title: 'Weekly',
              price: '\$2.99/week',
              isPopular: false,
            ),
            const SizedBox(height: AppSpacing.sm),
            const _PlanTile(
              title: 'Monthly',
              price: '\$7.99/month',
              isPopular: true,
            ),
            const SizedBox(height: AppSpacing.sm),
            const _PlanTile(
              title: 'Yearly',
              price: '\$49.99/year',
              isPopular: false,
            ),
            const Spacer(),
            PrimaryButton(
              label: 'Continue',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('In-app purchase not enabled in v1'),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Maybe later'),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _PlanTile extends StatelessWidget {
  final String title;
  final String price;
  final bool isPopular;

  const _PlanTile({
    required this.title,
    required this.price,
    required this.isPopular,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        side: isPopular
            ? const BorderSide(color: AppColors.primary, width: 2)
            : BorderSide.none,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        title: Row(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            if (isPopular) ...[
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('Popular',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ],
        ),
        subtitle: Text(price),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
