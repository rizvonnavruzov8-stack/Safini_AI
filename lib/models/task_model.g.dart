// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SafiniTaskAdapter extends TypeAdapter<SafiniTask> {
  @override
  final int typeId = 1;

  @override
  SafiniTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SafiniTask(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      category: fields[3] as TaskCategory,
      coins: fields[4] as int,
      isCompleted: fields[5] as bool,
      isApproved: fields[6] as bool,
      proof: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SafiniTask obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.coins)
      ..writeByte(5)
      ..write(obj.isCompleted)
      ..writeByte(6)
      ..write(obj.isApproved)
      ..writeByte(7)
      ..write(obj.proof);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SafiniTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskCategoryAdapter extends TypeAdapter<TaskCategory> {
  @override
  final int typeId = 0;

  @override
  TaskCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskCategory.language;
      case 1:
        return TaskCategory.movement;
      case 2:
        return TaskCategory.brain;
      case 3:
        return TaskCategory.realWorld;
      case 4:
        return TaskCategory.social;
      default:
        return TaskCategory.language;
    }
  }

  @override
  void write(BinaryWriter writer, TaskCategory obj) {
    switch (obj) {
      case TaskCategory.language:
        writer.writeByte(0);
        break;
      case TaskCategory.movement:
        writer.writeByte(1);
        break;
      case TaskCategory.brain:
        writer.writeByte(2);
        break;
      case TaskCategory.realWorld:
        writer.writeByte(3);
        break;
      case TaskCategory.social:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
