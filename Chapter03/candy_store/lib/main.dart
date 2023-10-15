import 'package:candy_store/cart_view_model.dart';
import 'package:candy_store/cart_view_model_provider.dart';
import 'package:candy_store/faves/data/api/local_storage_api.g.dart';
import 'package:candy_store/faves/data/local_faves_repository.dart';
import 'package:candy_store/faves/domain/faves_repository.dart';
import 'package:candy_store/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// At this point, all of the code is in the `lib` folder and we will sort it in Part 3
// TODO: This code should be updated in the previous chapters (6, 7, 8)
void main() {
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FavesRepository>(
          create: (_) => LocalFavesRepository(
            api: LocalStorageApi(),
          ),
        ),
      ],
      child: CartViewModelProvider(
        cartViewModel: CartViewModel(),
        child: MaterialApp(
          title: 'Candy shop',
          theme: ThemeData(
            primarySwatch: Colors.lime,
          ),
          home: const MainPage(),
        ),
      ),
    ),
  );
}
