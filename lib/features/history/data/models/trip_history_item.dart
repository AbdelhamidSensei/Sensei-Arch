import 'package:hive/hive.dart';

class TripHistoryItem extends HiveObject {
  final String id;
  final String fromStationId;
  final String toStationId;
  final int totalMinutes;
  final int totalStations;
  final int fareEGP;
  final DateTime createdAt;

  TripHistoryItem({
    required this.id,
    required this.fromStationId,
    required this.toStationId,
    required this.totalMinutes,
    required this.totalStations,
    required this.fareEGP,
    required this.createdAt,
  });
}

class TripHistoryItemAdapter extends TypeAdapter<TripHistoryItem> {
  @override
  final int typeId = 2;

  @override
  TripHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TripHistoryItem(
      id: fields[0] as String,
      fromStationId: fields[1] as String,
      toStationId: fields[2] as String,
      totalMinutes: fields[3] as int,
      totalStations: fields[4] as int,
      fareEGP: fields[5] as int,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TripHistoryItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fromStationId)
      ..writeByte(2)
      ..write(obj.toStationId)
      ..writeByte(3)
      ..write(obj.totalMinutes)
      ..writeByte(4)
      ..write(obj.totalStations)
      ..writeByte(5)
      ..write(obj.fareEGP)
      ..writeByte(6)
      ..write(obj.createdAt);
  }
}
