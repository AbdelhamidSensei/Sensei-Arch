import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sensei/features/branch_selection/domain/model/selected_branch.dart';
import 'package:sensei/features/branch_selection/domain/repository/branch_repository.dart';

class BranchRepositoryImpl implements BranchRepository {
  BranchRepositoryImpl({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  static const String _key = 'selected_branch';

  @override
  Future<void> saveBranch(SelectedBranch branch) async {
    await _prefs.setString(_key, jsonEncode(branch.toJson()));
  }

  @override
  Future<SelectedBranch?> getSavedBranch() async {
    final json = _prefs.getString(_key);
    if (json == null) return null;
    try {
      return SelectedBranch.fromJson(
          jsonDecode(json) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearBranch() async {
    await _prefs.remove(_key);
  }
}
