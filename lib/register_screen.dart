// lib/register_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Các biến để lấy dữ liệu từ ô nhập liệu
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(), // .trim() để xóa khoảng trắng
        password: _passwordController.text.trim(),
      );

      // *** THÊM PHẦN NÀY VÀO ***
      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        // Nếu user tồn tại và email chưa được xác thực
        // Gửi email xác thực
        await user.sendEmailVerification();

        // Thông báo cho người dùng
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đăng ký thành công! Vui lòng kiểm tra email để xác thực tài khoản.')),
          );
        }
      }
      // *** KẾT THÚC PHẦN THÊM ***

      // Quay lại màn hình đăng nhập
      if (mounted) {
        Navigator.of(context).pop();
      }

      // // Nếu đăng ký thành công, hiển thị thông báo
      // if (mounted) { // Kiểm tra xem widget còn tồn tại không
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Đăng ký thành công! Vui lòng đăng nhập.')),
      //   );
      //   // Quay lại màn hình đăng nhập
      //   Navigator.of(context).pop();
      // }

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