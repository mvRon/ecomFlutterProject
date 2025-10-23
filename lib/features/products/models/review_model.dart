import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String? id;
  final String userName;
  final double rating;
  final String text;
  final Timestamp createdAt;

  Review({
    this.id,
    required this.userName,
    required this.rating,
    required this.text,
    required this.createdAt,
  });

  factory Review.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Review(
      id: snapshot.id,
      userName: data['userName'],
      rating: (data['rating'] as num).toDouble(),
      text: data['text'],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'rating': rating,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}