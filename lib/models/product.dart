import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  final String unit;

  Product({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.unit,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
