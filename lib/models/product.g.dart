// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    id: json['id'] as String,
    image: json['image'] as String,
    rating: (json['rating'] as num)?.toDouble(),
    isFavourite: json['isFavourite'] as bool,
    isPopular: json['isPopular'] as bool,
    name: json['name'] as String,
    price: (json['price'] as num)?.toDouble(),
    description: json['description'] as String,
    category: json['category'] as String,
  )..numOfItems = json['numOfItems'] as int;
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'image': instance.image,
      'rating': instance.rating,
      'price': instance.price,
      'isFavourite': instance.isFavourite,
      'isPopular': instance.isPopular,
      'numOfItems': instance.numOfItems,
    };
