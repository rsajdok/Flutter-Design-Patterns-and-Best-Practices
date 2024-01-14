import 'package:candy_store/cart/presentation/bloc/cart_bloc.dart';
import 'package:candy_store/cart/presentation/bloc/cart_event.dart';
import 'package:candy_store/product/presentation/bloc/products_bloc.dart';
import 'package:candy_store/product/presentation/widget/product_list_item_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsBloc(GetIt.I.get())
        ..add(
          const ProductsFetched(),
        ),
      child: _ProductsView(),
    );
  }
}

class _ProductsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = context.select((ProductsBloc bloc) => bloc.state.items);
    final progress = context
        .select((ProductsBloc bloc) => bloc.state.loadingResult)
        .isInProgress;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                context.read<ProductsBloc>().add(ProductsSearched(query));
              },
            ),
          ),
          const SizedBox(height: 16),
          if (progress) const CircularProgressIndicator(),
          if (items.isEmpty && !progress) const Text('No items found'),
          if (items.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ProductListItemView(
                    item: item,
                    onAddToCart: (item) {
                      context.read<CartBloc>().add(AddItem(item));
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
