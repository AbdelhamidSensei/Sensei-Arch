import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sensei/features/auth/domain/model/user_model.dart';
import 'package:sensei/features/branch_selection/di/branch_selection_providers.dart';
import 'package:sensei/features/branch_selection/presentation/branch_selection_ui_state.dart';

class BranchSelectionScreen extends ConsumerWidget {
  const BranchSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(branchSelectionViewModelProvider);

    ref.listen<BranchSelectionUiState>(
      branchSelectionViewModelProvider,
      (prev, next) {
        if (next.isNavigating && prev?.isNavigating != true) {
          context.go('/home/open');
        }
      },
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'IDH',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB20018),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Select Branch',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xFFB20018)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xFFB20018)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xFFB20018), width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        hint: const Text('Choose a branch'),
                        value: state.selectedBranch?.branchID,
                        items: state.branches
                            .map((b) => DropdownMenuItem(
                                  value: b.id,
                                  child: Text(b.name),
                                ))
                            .toList(),
                        onChanged: (branchId) {
                          if (branchId == null) return;
                          final branch = state.branches
                              .firstWhere((b) => b.id == branchId);
                          ref
                              .read(branchSelectionViewModelProvider.notifier)
                              .selectBranch(branch);
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: state.selectedBranch != null
                              ? () => ref
                                  .read(branchSelectionViewModelProvider
                                      .notifier)
                                  .confirmSelection()
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB20018),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
