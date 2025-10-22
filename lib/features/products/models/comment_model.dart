import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String? id;
  final String userId;
  final String text;
  final Timestamp createdAt;

  Comment({
    this.id,
    required this.userId,
    required this.text,
    required this.createdAt,
  });

  factory Comment.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Comment(
      id: snapshot.id,
      userId: data['userId'],
      text: data['text'],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}