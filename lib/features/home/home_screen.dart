// lib/features/home/home_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth/login_screen.dart'; // Để quay lại khi đăng xuất

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy thông tin người dùng hiện tại
    final User? user = FirebaseAuth.instance.currentUser;

    //log dữ liệu người dùng
    print('Đã đăng nhập với email: ${user}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang Chủ'),
        actions: [
          // Nút đăng xuất
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // Quay lại màn hình Login
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Chào mừng, ${user?.email ?? 'Bạn'}!\nBạn đã đăng nhập thành công.',
          textAlign: TextAlign.center,
        ),
      ),
      // Đây là nơi bạn sẽ bắt đầu kết nối với Realtime Database
      // ví dụ: để hiển thị danh sách công việc, hồ sơ người dùng, v.v.
    );
  }
}