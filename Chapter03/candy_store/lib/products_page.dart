import 'package:candy_store/faves/presentation/view/faves_page.dart';
import 'package:candy_store/product_list_item_view.dart';
import 'package:candy_store/products.dart';
import 'package:flutter/material.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            onPressed: _openFavourites,
            icon: const Icon(Icons.favorite),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: Products.items.length,
        itemBuilder: (context, index) {
          final item = Products.items[index];
          return ProductListItemView(item: item);
        },
      ),
    );
  }

  void _openFavourites() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FavesPage.withBloc(),
      ),
    );
  }
}
