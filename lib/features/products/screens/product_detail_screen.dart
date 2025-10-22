import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_detail_provider.dart';
import '../widgets/review_list_item.dart';
import '../widgets/comment_section.dart';
import 'add_edit_product_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({Key? key, required this.productId}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Dùng addPostFrameCallback để provider được gọi sau khi widget build xong frame đầu tiên
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductDetailProvider>(context, listen: false)
          .fetchProductDetails(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProductDetailProvider>(
        builder: (context, provider, child) {
          final product = provider.product;
          final reviews = provider.reviews;

          if (provider.isLoading && product == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (product == null) {
            return const Center(child: Text('Không tìm thấy sản phẩm.'));
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(product.name, style: const TextStyle(shadows: [Shadow(blurRadius: 8)])),
                  background: Hero(
                    tag: 'product-image-${product.id}',
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(child: Icon(Icons.broken_image)),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => AddEditProductScreen(product: product),
                      ));
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.green),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          const SizedBox(width: 8),
                          Text(
                            '${product.avgRating.toStringAsFixed(1)} (${product.reviewCount} đánh giá)',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Đánh giá (${reviews.length})', style: Theme.of(context).textTheme.titleLarge),
                ),
              ),
              if (reviews.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Center(child: Text('Chưa có đánh giá nào.')),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => ReviewListItem(review: reviews[index]),
                    childCount: reviews.length,
                  ),
                ),
              SliverToBoxAdapter(
                child: CommentSection(productId: product.id!),
              ),
            ],
          );
        },
      ),
    );
  }
}

