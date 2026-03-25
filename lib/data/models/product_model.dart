// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:smart_lunch/data/models/product_category_model.dart';

class ProductModel {
  final int? id;
  final String? imageUrl;
  final String? name;
  final int? category;
  final double? price;
  final List<String>? ingredients;
  final String? availableDays;
  final String? description;
  final int? stock;
  final String? sku;
  final bool? inventariable;
  ProductModel({
    this.id,
    this.imageUrl,
    this.name,
    this.category,
    this.price,
    this.ingredients,
    this.availableDays,
    this.description,
    this.stock,
    this.sku,
    this.inventariable,
  });

  ProductModel copyWith({
    int? id,
    String? imageUrl,
    String? name,
    int? category,
    double? price,
    List<String>? ingredients,
    String? availableDays,
    String? description,
    int? stock,
    String? sku,
    bool? inventariable,
  }) {
    return ProductModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      ingredients: ingredients ?? this.ingredients,
      availableDays: availableDays ?? this.availableDays,
      description: description ?? this.description,
      stock: stock ?? this.stock,
      sku: sku ?? this.sku,
      inventariable: inventariable ?? this.inventariable,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'imageUrl': imageUrl,
      'name': name,
      'category': category,
      'price': price,
      'ingredients': ingredients,
      'availableDays': availableDays,
      'description': description,
      'stock': stock,
      'sku': sku,
      'inventariable': inventariable,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] != null ? map['id'] as int : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      name: map['name'] != null
          ? map['name'] as String
          : null,
      category: map['category'] != null ? map['category'] as int : null,
      price: map['price'] != null
          ? (map['price'] is num
                ? (map['price'] as num).toDouble()
                : double.parse(map['price'].toString()))
          : null,
      ingredients: map['ingredients'] != null
          ? (map['ingredients'] as List)
                .map((e) => e['name'] as String)
                .toList()
          : null,
      availableDays: map['availableDays'] != null
          ? map['availableDays'] as String
          : null,
      description: map['description'] != null
          ? map['description'] as String
          : null,
      stock: map['stock'] != null ? map['stock'] as int : null,
      sku: map['sku'] != null ? map['sku'] as String : null,
      inventariable: map['inventariable'] != null
          ? map['inventariable'] as bool
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(Map<String, dynamic> source) =>
      ProductModel.fromMap(source);
}
