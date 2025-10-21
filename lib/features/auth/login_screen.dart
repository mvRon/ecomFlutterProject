// lib/features/auth/login_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../home/home_screen.dart';      // Màn hình sẽ đến sau khi đăng nhập
import 'register_screen.dart'; // Màn hình đăng ký

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  // Hàm xử lý đăng nhập
  Future<void> _login() async {
    // Ẩn bàn phím
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      // Dùng Firebase Auth để đăng nhập
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // *** THAY THẾ PHẦN CHUYỂN TRANG BẰNG LOGIC NÀY ***
      User? user = userCredential.user;

      //log dữ liệu user
      print('Đăng nhập với user: $user');

      if (user != null) {
        // BẮT BUỘC: Tải lại thông tin user để cập nhật trạng thái mới nhất
        await user.reload();

        if (!mounted) return; // Luôn kiểm tra context sau một lệnh await

        if (user.emailVerified) {
          // 1. ĐÃ XÁC THỰC: Cho vào HomeScreen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          // 2. CHƯA XÁC THỰC: Hiển thị hộp thoại cảnh báo
          // Đợi cho đến khi dialog được đóng lại
          await showDialog(
            context: context,
            barrierDismissible: false, // Ngăn người dùng đóng dialog bằng cách bấm ra ngoài
            builder: (context) => AlertDialog(
              title: const Text('Chưa Xác Thực Email'),
              content: const Text(
                  'Tài khoản của bạn chưa được xác thực. Vui lòng kiểm tra hộp thư đến hoặc gửi lại email.'),
              actions: [
                TextButton(
                  child: const Text('Gửi lại email'),
                  onPressed: () async {
                    // Xử lý gửi lại email
                    await user.sendEmailVerification();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã gửi lại email xác thực.')),
                      );
                      Navigator.of(context).pop(); // Đóng dialog
                    }
                  },
                ),
                TextButton(
                  child: const Text('Đóng'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Đóng dialog
                  },
                ),
              ],
            ),
          );

          // Đăng xuất người dùng SAU KHI dialog đã đóng.
          // Điều này đảm bảo user vẫn đang đăng nhập khi họ bấm "Gửi lại email".
          await _auth.signOut();
        }
      }
      // *** KẾT THÚC PHẦN THAY THẾ ***

    } on FirebaseAuthException catch (e) {
      // Đây là phần bạn yêu cầu:
      // Nếu thông tin không đúng, hiển thị thông báo
      // 'user-not-found' hoặc 'wrong-password' đều trả về chung 1 lỗi
      // để tăng tính bảo mật (kẻ xấu không biết là sai email hay sai mật khẩu)
      String errorMessage = 'Tên đăng nhập và mật khẩu không đúng.';

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã xảy ra lỗi: $e')),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Hàm xử lý quên mật khẩu
  Future<void> _forgotPassword() async {
    final TextEditingController resetEmailController = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Đặt lại mật khẩu'),
          content: TextField(
            controller: resetEmailController,
            decoration: const InputDecoration(hintText: "Nhập email của bạn"),
            keyboardType: TextInputType.emailAddress,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Gửi'),
              onPressed: () async {
                final String email = resetEmailController.text.trim();
                if (email.isNotEmpty) {
                  try {
                    await _auth.sendPasswordResetEmail(email: email);
                    if (mounted) {
                      Navigator.of(context).pop(); // Đóng dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Đã gửi liên kết đặt lại mật khẩu. Vui lòng kiểm tra email.'),
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Nếu email tồn tại, một liên kết sẽ được gửi đến đó.')),
                      );
                    }
                  }
                }
              },
            ),
          ],
        );
      },
    );
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
      appBar: AppBar(title: const Text('Đăng Nhập')),
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
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _login,
                child: const Text('Đăng Nhập'),
              ),
            TextButton(
              onPressed: _forgotPassword,
              child: const Text('Quên mật khẩu?'),
            ),
            // Nút để chuyển qua màn hình đăng ký
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                );
              },
              child: const Text('Chưa có tài khoản? Đăng ký ngay'),
            ),
          ],
        ),
      ),
    );
  }
}
