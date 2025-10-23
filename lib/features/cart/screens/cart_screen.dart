import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
      ),
      body: const Center(
        child: Text(
          'Tính năng giỏ hàng sẽ sớm được phát triển!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

