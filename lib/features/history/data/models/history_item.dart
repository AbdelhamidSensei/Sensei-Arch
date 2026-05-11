import 'package:hive/hive.dart';

part 'history_item.g.dart';

@HiveType(typeId: 1)
class HistoryItem extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String originalPath;

  @HiveField(2)
  String resultPath;

  @HiveField(3)
  String mode;

  @HiveField(4)
  DateTime createdAt;

  HistoryItem({
    required this.id,
    required this.originalPath,
    required this.resultPath,
    required this.mode,
    required this.createdAt,
  });
}
