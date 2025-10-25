import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/review_model.dart';
import '../models/comment_model.dart';
import '../services/product_service.dart';

class ProductDetailProvider with ChangeNotifier {
  final ProductService _productService = ProductService();

  Product? _product;
  List<Review> _reviews = [];
  List<Comment> _comments = [];
  bool _isLoading = false;

  Product? get product => _product;
  List<Review> get reviews => _reviews;
  List<Comment> get comments => _comments;
  bool get isLoading => _isLoading;

  Future<void> fetchProductDetails(String productId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Lắng nghe sự thay đổi của cả 3 stream cùng lúc
      _productService.getProductById(productId).listen((product) {
        _product = product;
        notifyListeners();
      });

      _productService.getReviews(productId).listen((reviews) {
        _reviews = reviews;
        notifyListeners();
      });

      _productService.getComments(productId).listen((comments) {
        _comments = comments;
        notifyListeners();
      });

    } catch (e) {
      print(e); // Handle error
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addReview(String productId, Review review) async {
    try {
      await _productService.addReview(productId, review);
      // Logic cập nhật avgRating nên được xử lý ở backend (Cloud Function)
      // Ở đây ta không cần fetch lại data vì đang dùng Stream
    } catch (e) {
      print(e); // Handle error
    }
  }

  Future<void> addComment(String productId, Comment comment) async {
    try {
      await _productService.addComment(productId, comment);
    } catch (e) {
      print(e); // Handle error
    }
  }
}

