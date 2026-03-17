// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AvatarItemAdapter extends TypeAdapter<AvatarItem> {
  @override
  final int typeId = 6;

  @override
  AvatarItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AvatarItem(
      id: fields[0] as String,
      name: fields[1] as String,
      cost: fields[2] as int,
      category: fields[3] as AvatarCategory,
      iconPath: fields[4] as String,
      isOwned: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AvatarItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.cost)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.iconPath)
      ..writeByte(5)
      ..write(obj.isOwned);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AvatarItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AvatarCategoryAdapter extends TypeAdapter<AvatarCategory> {
  @override
  final int typeId = 5;

  @override
  AvatarCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AvatarCategory.outfit;
      case 1:
        return AvatarCategory.face;
      case 2:
        return AvatarCategory.hair;
      case 3:
        return AvatarCategory.back;
      case 4:
        return AvatarCategory.effects;
      default:
        return AvatarCategory.outfit;
    }
  }

  @override
  void write(BinaryWriter writer, AvatarCategory obj) {
    switch (obj) {
      case AvatarCategory.outfit:
        writer.writeByte(0);
        break;
      case AvatarCategory.face:
        writer.writeByte(1);
        break;
      case AvatarCategory.hair:
        writer.writeByte(2);
        break;
      case AvatarCategory.back:
        writer.writeByte(3);
        break;
      case AvatarCategory.effects:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AvatarCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
