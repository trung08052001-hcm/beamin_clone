import 'package:json_annotation/json_annotation.dart';

part 'restaurant.g.dart';

@JsonSerializable()
class Restaurant {
  final String name;
  final String imageUrl;
  final double rating;
  final String totalReviews;
  final String deliveryTime;
  final String description;
  final bool isFreeship;
  final String category;

  Restaurant({
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.totalReviews,
    required this.deliveryTime,
    required this.description,
    required this.isFreeship,
    required this.category,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}

