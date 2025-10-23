// lib/features/auth/register_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../user/models/user_model.dart'; // Import UserModel
import '../user/services/user_service.dart'; // Import UserService
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService(); // Khởi tạo UserService
  bool _isLoading = false; // Biến để hiển thị trạng thái đang tải

  // Hàm xử lý đăng ký
  Future<void> _register() async {
    // Ẩn bàn phím
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true; // Bắt đầu tải
    });

    try {
      // Sử dụng Firebase Auth để tạo người dùng mới
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(), // .trim() để xóa khoảng trắng
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        // Gửi email xác thực
        await user.sendEmailVerification();

        // TẠO USER TRONG FIRESTORE
        final newUser = UserModel(
          uid: user.uid,
          email: user.email!,
          displayName: 'New User', // Tên mặc định
        );
        await _userService.saveUser(newUser);


        // Hiển thị thông báo và quay về màn hình đăng nhập
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đăng ký thành công! Vui lòng kiểm tra email để xác thực tài khoản.')),
          );
        }
      }

      // Quay lại màn hình đăng nhập
      if (mounted) {
        Navigator.of(context).pop();
      }


    } on FirebaseAuthException catch (e) {
      // Nếu có lỗi (ví dụ: email đã tồn tại, mật khẩu quá yếu)
      String errorMessage = 'Đã xảy ra lỗi. Vui lòng thử lại.';
      if (e.code == 'weak-password') {
        errorMessage = 'Mật khẩu quá yếu.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Email này đã được sử dụng.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Email không hợp lệ.';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      // Các lỗi khác
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã xảy ra lỗi: $e')),
        );
      }
    }

    setState(() {
      _isLoading = false; // Kết thúc tải
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng Ký Tài Khoản')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Mật khẩu'),
              obscureText: true, // Ẩn mật khẩu
            ),
            const SizedBox(height: 20),
            // Nếu đang tải thì hiển thị vòng xoay, ngược lại hiển thị nút
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _register,
              child: const Text('Đăng Ký'),
            ),
          ],
        ),
      ),
    );
  }
}