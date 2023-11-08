import 'package:candy_store/cart_repository.dart';
import 'package:candy_store/in_memory_cart_repository.dart';
import 'package:candy_store/main_page.dart';
import 'package:candy_store/product_repository/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'product_repository/api_service.dart';
import 'product_repository/hive_service.dart';
import 'product_repository/product_api_data_source.dart';
import 'product_repository/product_hive_data_source.dart';

// At this point, all of the code is in the `lib` folder and we will sort it in Part 3
Future<void> main() async {
  await _setupDependencies();
  runApp(
    MaterialApp(
      title: 'Candy shop',
      theme: ThemeData(
        primarySwatch: Colors.lime,
      ),
      home: MainPage.withBloc(),
    ),
  );
}

Future<void> _setupDependencies() async {
  final getIt = GetIt.instance;
  getIt.registerLazySingleton<ICartRepository>(() => InMemoryCartRepository());
  getIt.registerSingletonAsync<IProductRepository>(() async {
    final hiveService = HiveService();
    final apiService = ApiService();
    await hiveService.initializeHive();
    return ProductRepository(
      remoteDataSource: ProductApiDataSource(apiService),
      localDataSource: ProductHiveDataSource(
        hiveService.getProductBox(),
      ),
    );
  });
  await getIt.allReady();
}
