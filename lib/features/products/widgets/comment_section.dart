import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/comment_model.dart';
import '../providers/product_detail_provider.dart';
import 'package:intl/intl.dart';

class CommentSection extends StatefulWidget {
  final String productId;

  const CommentSection({Key? key, required this.productId}) : super(key: key);

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPosting = false;
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> _postComment() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isPosting = true);

      final comment = Comment(
        // TODO: Thay bằng ID của user đang đăng nhập
        userId: user?.email ?? 'anonymous',
        text: _commentController.text,
        createdAt: Timestamp.now(), // Sẽ được thay bằng serverTimestamp ở model
      );

      try {
        await Provider.of<ProductDetailProvider>(context, listen: false)
            .addComment(widget.productId, comment);
        _commentController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gửi bình luận thất bại: $e')),
        );
      } finally {
        setState(() => _isPosting = false);
      }
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comments = Provider.of<ProductDetailProvider>(context).comments;

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bình luận (${comments.length})', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          _buildCommentInput(),
          const SizedBox(height: 16),
          if (comments.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text('Chưa có bình luận nào.')),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: comments.length,
              itemBuilder: (ctx, i) => _buildCommentItem(comments[i]),
            ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Form(
      key: _formKey,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: 'Viết bình luận...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              validator: (value) => (value == null || value.trim().isEmpty) ? 'Bình luận không được để trống' : null,
              maxLines: null, // Tự động xuống dòng
            ),
          ),
          const SizedBox(width: 8),
          _isPosting
              ? const CircularProgressIndicator()
              : IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _postComment,
                  color: Theme.of(context).primaryColor,
                ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Comment comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(child: Icon(Icons.person)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // TODO: Thay bằng tên user thật
                  '${comment.userId}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(comment.text),
                const SizedBox(height: 4),
                Text(
                  DateFormat.yMd().add_jm().format(comment.createdAt.toDate()),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

