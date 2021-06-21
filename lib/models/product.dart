import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  String id;
  String name, description, category;
  String image;
  double rating, price;
  bool isFavourite, isPopular;
  int numOfItems = 1;

  Product(
      {this.id,
      this.image,
      this.rating = 0.0,
      this.isFavourite = false,
      this.isPopular = false,
      this.name,
      this.price,
      this.description,
      this.category});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  @override
  String toString() {
    return 'Product{id:$id,name:$name,description:$description,category:$category,image:$image}';
  }
}

