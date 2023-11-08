import 'package:candy_store/cart_repository.dart';
import 'package:candy_store/in_memory_cart_repository.dart';
import 'package:candy_store/main_page.dart';
import 'package:candy_store/product_repository/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'product_repository/api_service.dart';
import 'product_repository/hive_service.dart';
import 'product_repository/product_api_data_source.dart';
import 'product_repository/product_hive_data_source.dart';

final hiveService = HiveService();
final apiService = ApiService();
// At this point, all of the code is in the `lib` folder and we will sort it in Part 3
Future<void> main() async {
  await hiveService.initializeHive();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IProductRepository>(
          create: (_) => ProductRepository(
            remoteDataSource: ProductApiDataSource(apiService),
            localDataSource: ProductHiveDataSource(
              hiveService.getProductBox(),
            ),
          ),
        ),
        RepositoryProvider<ICartRepository>(
          create: (_) => InMemoryCartRepository(),
        ),
      ],
      child: MaterialApp(
        title: 'Candy shop',
        theme: ThemeData(
          primarySwatch: Colors.lime,
        ),
        home: MainPage.withBloc(),
      ),
    ),
  );
}
