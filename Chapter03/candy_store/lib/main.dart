import "package:candy_store/cart_view_model.dart";
import "package:candy_store/cart_view_model_provider.dart";
import "package:candy_store/main_page.dart";
import "package:flutter/material.dart";

// At this point, all of the code is in the `lib` folder and we will sort it in Part 3
// TODO: Merge changes from other chapters into this branch once they are done
void main() {
  runApp(
    CartViewModelProvider(
      cartViewModel: CartViewModel(),
      child: MaterialApp(
        title: "Candy shop",
        theme: ThemeData(
          primarySwatch: Colors.lime,
        ),
        home: const MainPage(),
      ),
    ),
  );
}
