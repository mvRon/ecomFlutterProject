import 'package:flutter/material.dart';
import '../models/review_model.dart';
import 'package:intl/intl.dart'; // Cần thêm package intl: flutter pub add intl

class ReviewListItem extends StatelessWidget {
  final Review review;

  const ReviewListItem({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // TODO: Thay thế bằng tên user thật khi có hệ thống user
                Text('${review.userId.substring(0, 6)}...', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  DateFormat.yMd().add_jm().format(review.createdAt.toDate()),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < review.rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 20,
                );
              }),
            ),
            const SizedBox(height: 8),
            Text(review.text),
          ],
        ),
      ),
    );
  }
}

