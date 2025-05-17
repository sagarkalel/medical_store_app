// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 2;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      id: fields[0] as String?,
      name: fields[1] as String,
      description: fields[2] as String,
      price: fields[3] as double,
      discountPercentage: fields[4] as double,
      brand: fields[5] as String,
      imageUrls: (fields[6] as List).cast<String>(),
      category: fields[7] as String,
      stockQuantity: fields[8] as int,
      dosage: fields[9] as String,
      uses: fields[10] as String,
      sideEffects: fields[11] as String,
      expiryDate: fields[12] as DateTime,
      prescriptionRequired: fields[13] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.discountPercentage)
      ..writeByte(5)
      ..write(obj.brand)
      ..writeByte(6)
      ..write(obj.imageUrls)
      ..writeByte(7)
      ..write(obj.category)
      ..writeByte(8)
      ..write(obj.stockQuantity)
      ..writeByte(9)
      ..write(obj.dosage)
      ..writeByte(10)
      ..write(obj.uses)
      ..writeByte(11)
      ..write(obj.sideEffects)
      ..writeByte(12)
      ..write(obj.expiryDate)
      ..writeByte(13)
      ..write(obj.prescriptionRequired);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
