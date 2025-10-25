import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String? id;
  final String userId;
  final double rating;
  final String text;
  final Timestamp createdAt;

  Review({
    this.id,
    required this.userId,
    required this.rating,
    required this.text,
    required this.createdAt,
  });

  factory Review.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Review(
      id: snapshot.id,
      userId: data['userId'],
      rating: (data['rating'] as num).toDouble(),
      text: data['text'],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'rating': rating,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}