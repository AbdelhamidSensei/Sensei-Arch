import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:photo_revive_ai/features/history/data/models/history_item.dart';
import 'package:photo_revive_ai/features/history/data/repositories/history_repository_impl.dart';

void main() {
  late Box<HistoryItem> box;
  late HistoryRepositoryImpl repo;

  setUpAll(() async {
    final dir = Directory.systemTemp.createTempSync('hive_test_');
    Hive.init(dir.path);
    Hive.registerAdapter(HistoryItemAdapter());
    box = await Hive.openBox<HistoryItem>('test_history');
  });

  setUp(() async {
    await box.clear();
    repo = HistoryRepositoryImpl(box);
  });

  tearDownAll(() async {
    await box.close();
  });

  test('add and getAll returns items newest first', () async {
    final item1 = HistoryItem(
      id: '1',
      originalPath: '/a.jpg',
      resultPath: '/b.jpg',
      mode: 'enhance',
      createdAt: DateTime(2024, 1, 1),
    );
    final item2 = HistoryItem(
      id: '2',
      originalPath: '/c.jpg',
      resultPath: '/d.jpg',
      mode: 'restoreFace',
      createdAt: DateTime(2024, 6, 1),
    );

    await repo.add(item1);
    await repo.add(item2);

    final all = repo.getAll();
    expect(all.length, 2);
    expect(all.first.id, '2'); // newest first
  });

  test('delete removes item', () async {
    final item = HistoryItem(
      id: 'del-1',
      originalPath: '/a.jpg',
      resultPath: '/b.jpg',
      mode: 'enhance',
      createdAt: DateTime(2024, 1, 1),
    );

    await repo.add(item);
    expect(repo.getAll().length, 1);

    await repo.delete('del-1');
    expect(repo.getAll().length, 0);
  });

  test('clearAll removes everything', () async {
    for (int i = 0; i < 3; i++) {
      await repo.add(HistoryItem(
        id: 'item-$i',
        originalPath: '/a$i.jpg',
        resultPath: '/b$i.jpg',
        mode: 'enhance',
        createdAt: DateTime(2024, i + 1, 1),
      ));
    }

    expect(repo.getAll().length, 3);
    await repo.clearAll();
    expect(repo.getAll().length, 0);
  });
}
