import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final double avgRating;
  final int reviewCount;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.avgRating = 0.0,
    this.reviewCount = 0,
  });

  factory Product.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Product(
      id: snapshot.id,
      name: data['name'],
      description: data['description'] ?? '', // Thêm dòng này, ?? '' để tránh lỗi null
      price: (data['price'] as num).toDouble(),
      imageUrl: data['imageUrl'],
      avgRating: (data['avgRating'] as num).toDouble(),
      reviewCount: (data['reviewCount'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'avgRating': avgRating,
      'reviewCount': reviewCount,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}