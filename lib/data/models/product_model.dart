import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'product_model.g.dart';

@HiveType(typeId: 2)
class ProductModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  double price;

  @HiveField(4)
  double discountPercentage;

  @HiveField(5)
  final String brand;

  @HiveField(6)
  List<String> imageUrls;

  @HiveField(7)
  final String category;

  @HiveField(8)
  final int stockQuantity;

  @HiveField(9)
  final String dosage;

  @HiveField(10)
  final String uses;

  @HiveField(11)
  final String sideEffects;

  @HiveField(12)
  DateTime expiryDate;

  @HiveField(13)
  bool prescriptionRequired;

  ProductModel({
    String? id,
    required this.name,
    required this.description,
    required this.price,
    this.discountPercentage = 0.0,
    required this.brand,
    required this.imageUrls,
    required this.category,
    required this.stockQuantity,
    required this.dosage,
    required this.uses,
    required this.sideEffects,
    required this.expiryDate,
    this.prescriptionRequired = false,
  }) : id = id ?? const Uuid().v4();

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as double,
      discountPercentage: json['discountPercentage'] as double,
      brand: json['brand'] as String,
      imageUrls: (json['imageUrls'] as List<dynamic>).cast<String>(),
      category: json['category'] as String,
      stockQuantity: json['stockQuantity'] as int,
      dosage: json['dosage'] as String,
      uses: json['uses'] as String,
      sideEffects: json['sideEffects'] as String,
      expiryDate: DateTime.parse(json['expiryDate'] as String),
      prescriptionRequired: json['prescriptionRequired'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'discountPercentage': discountPercentage,
      'brand': brand,
      'imageUrls': imageUrls,
      'category': category,
      'stockQuantity': stockQuantity,
      'dosage': dosage,
      'uses': uses,
      'sideEffects': sideEffects,
      'expiryDate': expiryDate.toIso8601String(),
      'prescriptionRequired': prescriptionRequired,
    };
  }

  double get discountedPrice {
    return price - (price * discountPercentage / 100);
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? discountPercentage,
    String? brand,
    List<String>? imageUrls,
    String? category,
    int? stockQuantity,
    String? dosage,
    String? uses,
    String? sideEffects,
    DateTime? expiryDate,
    bool? prescriptionRequired,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      brand: brand ?? this.brand,
      imageUrls: imageUrls ?? this.imageUrls,
      category: category ?? this.category,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      dosage: dosage ?? this.dosage,
      uses: uses ?? this.uses,
      sideEffects: sideEffects ?? this.sideEffects,
      expiryDate: expiryDate ?? this.expiryDate,
      prescriptionRequired: prescriptionRequired ?? this.prescriptionRequired,
    );
  }
}
