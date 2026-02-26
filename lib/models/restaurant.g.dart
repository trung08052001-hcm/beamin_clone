// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) => Restaurant(
  name: json['name'] as String,
  imageUrl: json['imageUrl'] as String,
  rating: (json['rating'] as num).toDouble(),
  totalReviews: json['totalReviews'] as String,
  deliveryTime: json['deliveryTime'] as String,
  description: json['description'] as String,
  isFreeship: json['isFreeship'] as bool,
  category: json['category'] as String,
);

Map<String, dynamic> _$RestaurantToJson(Restaurant instance) =>
    <String, dynamic>{
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'rating': instance.rating,
      'totalReviews': instance.totalReviews,
      'deliveryTime': instance.deliveryTime,
      'description': instance.description,
      'isFreeship': instance.isFreeship,
      'category': instance.category,
    };
