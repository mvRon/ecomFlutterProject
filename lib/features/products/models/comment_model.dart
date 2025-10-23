import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String? id;
  final String userName;
  final String text;
  final Timestamp createdAt;

  Comment({
    this.id,
    required this.userName,
    required this.text,
    required this.createdAt,
  });

  factory Comment.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Comment(
      id: snapshot.id,
      userName: data['userName'],
      text: data['text'],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}