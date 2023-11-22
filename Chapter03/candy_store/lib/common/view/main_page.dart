import 'package:candy_store/cart/cart.dart';
import 'package:candy_store/product/presentation/view/products_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

// TODO: Cherry pick this `super.key` commit into CH3 & CH4 branches
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();

  static Widget withBloc() {
    return BlocProvider<CartBloc>(
      create: (context) => CartBloc(
        GetIt.I.get(),
      )..add(const Load()),
      child: const MainPage(),
    );
  }
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final totalItemsCount =
        context.select<CartBloc, int>((bloc) => bloc.state.totalItems);

    return Stack(
      children: [
        const ProductsPage(),
        Positioned(
          right: 16,
          bottom: 16,
          child: GestureDetector(
            onTap: openCart,
            child: CartButton(
              count: totalItemsCount,
            ),
          ),
        ),
      ],
    );
  }

  void openCart() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<CartBloc>(),
          child: const CartPage(),
        ),
      ),
    );
  }
}
