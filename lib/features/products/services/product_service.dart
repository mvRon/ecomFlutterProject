import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../models/review_model.dart';
import '../models/comment_model.dart'; // Bạn tự tạo model này nhé

class ProductService {
  final CollectionReference _productCollection =
  FirebaseFirestore.instance.collection('products');

  // --- CRUD CHO SẢN PHẨM (PRODUCTS) ---

  // CREATE: Thêm sản phẩm
  Future<DocumentReference> addProduct(Product product) {
    return _productCollection.add(product.toJson());
  }

  // READ: Lấy danh sách sản phẩm (real-time)
  Stream<List<Product>> getProducts() {
    return _productCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Product.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    });
  }

  // READ: Lấy chi tiết 1 sản phẩm (real-time)
  Stream<Product> getProductById(String productId) {
    return _productCollection
        .doc(productId)
        .snapshots()
        .map((snapshot) => Product.fromSnapshot(snapshot as DocumentSnapshot<Map<String, dynamic>>));
  }

  // UPDATE: Cập nhật sản phẩm
  Future<void> updateProduct(Product product) {
    return _productCollection.doc(product.id).update(product.toJson());
  }

  // DELETE: Xóa sản phẩm
  Future<void> deleteProduct(String productId) {
    // Lưu ý: Việc xóa này KHÔNG tự động xóa sub-collections.
    // Bạn sẽ cần một Cloud Function để dọn dẹp reviews/comments
    return _productCollection.doc(productId).delete();
  }

  // --- CRUD CHO ĐÁNH GIÁ (REVIEWS) ---

  // Helper lấy collection reviews
  CollectionReference _getReviewCollection(String productId) {
    return _productCollection.doc(productId).collection('reviews');
  }

  // CREATE: Thêm đánh giá
  Future<void> addReview(String productId, Review review) {
    // TODO: Sau khi thêm thành công, bạn cần
    // 1. Lấy tất cả reviews của sản phẩm này
    // 2. Tính lại avgRating và reviewCount
    // 3. Cập nhật lại document `products/{productId}`
    // (Đây là phần logic phức tạp, thường làm bằng Cloud Function)
    return _getReviewCollection(productId).add(review.toJson());
  }

  // READ: Lấy danh sách đánh giá của 1 sản phẩm
  Stream<List<Review>> getReviews(String productId) {
    return _getReviewCollection(productId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Review.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    });
  }

  // --- CRUD CHO BÌNH LUẬN (COMMENTS) ---

  // Helper lấy collection comments
  CollectionReference _getCommentCollection(String productId) {
    return _productCollection.doc(productId).collection('comments');
  }

  // CREATE: Thêm bình luận
  Future<void> addComment(String productId, Comment comment) {
    return _getCommentCollection(productId).add(comment.toJson());
  }

  // READ: Lấy danh sách bình luận của 1 sản phẩm
  Stream<List<Comment>> getComments(String productId) {
    return _getCommentCollection(productId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Comment.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    });
  }
}