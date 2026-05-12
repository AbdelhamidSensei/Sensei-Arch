import 'package:hive/hive.dart';

class FavoriteItem extends HiveObject {
  final String id;
  final String? stationId;
  final String? fromStationId;
  final String? toStationId;
  final String label;
  final DateTime createdAt;

  FavoriteItem({
    required this.id,
    this.stationId,
    this.fromStationId,
    this.toStationId,
    required this.label,
    required this.createdAt,
  });
}

class FavoriteItemAdapter extends TypeAdapter<FavoriteItem> {
  @override
  final int typeId = 1;

  @override
  FavoriteItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteItem(
      id: fields[0] as String,
      stationId: fields[1] as String?,
      fromStationId: fields[2] as String?,
      toStationId: fields[3] as String?,
      label: fields[4] as String,
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.stationId)
      ..writeByte(2)
      ..write(obj.fromStationId)
      ..writeByte(3)
      ..write(obj.toStationId)
      ..writeByte(4)
      ..write(obj.label)
      ..writeByte(5)
      ..write(obj.createdAt);
  }
}
