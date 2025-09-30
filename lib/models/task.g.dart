// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 1;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      title: fields[0] as String,
      description: fields[1] as String,
      slimeColor: fields[2] as SlimeColor,
      isCompleted: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.slimeColor)
      ..writeByte(3)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SlimeColorAdapter extends TypeAdapter<SlimeColor> {
  @override
  final int typeId = 0;

  @override
  SlimeColor read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SlimeColor.red;
      case 1:
        return SlimeColor.green;
      case 2:
        return SlimeColor.blue;
      default:
        return SlimeColor.red;
    }
  }

  @override
  void write(BinaryWriter writer, SlimeColor obj) {
    switch (obj) {
      case SlimeColor.red:
        writer.writeByte(0);
        break;
      case SlimeColor.green:
        writer.writeByte(1);
        break;
      case SlimeColor.blue:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SlimeColorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
