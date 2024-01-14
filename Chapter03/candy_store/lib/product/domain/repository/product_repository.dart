import 'package:candy_store/product/domain/repository/fake_search_data.dart';

import '../model/product.dart';
import '../../data/repository/product_api_data_source.dart';
import '../../data/repository/product_hive_data_source.dart';

abstract class IProductRepository {
  Future<List<Product>> getProducts();

  Future<List<Product>> searchProducts(String query);
}

class ProductRepository extends IProductRepository {
  ProductRepository({
    required ProductApiDataSource remoteDataSource,
    required ProductHiveDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final ProductApiDataSource _remoteDataSource;
  final ProductHiveDataSource _localDataSource;

  @override
  Future<List<Product>> getProducts() async {
    // Retrieve candies from local data source
    final localProducts = await _localDataSource.getProducts();

    // Check if local data source has data
    if (localProducts.isNotEmpty) {
      return localProducts;
    } else {
      // If local data source is empty, fetch from API and cache it locally
      final apiProducts = await _remoteDataSource.getProducts();
      await _localDataSource.cacheProducts(apiProducts);
      return apiProducts;
    }
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    final products = fakeSearchData;
    if (query.isEmpty) {
      return products;
    }
    final results = products.where((product) {
      if (product.name.toLowerCase().contains(query.toLowerCase())) {
        return true;
      }
      final nameDistance = _levenshteinDistance(
        product.name.toLowerCase(),
        query.toLowerCase(),
      );
      final descriptionDistance = _levenshteinDistance(
        product.description.toLowerCase(),
        query.toLowerCase(),
      );
      print(
          'query: $query, product: ${product.name}, nameDistance: $nameDistance, descriptionDistance: $descriptionDistance');
      return nameDistance <= 3 || descriptionDistance <= 3;
    }).toList();
    return results;
  }

  int _levenshteinDistance(String a, String b) {
    if (a == b) {
      return 0;
    }
    if (a.isEmpty) {
      return b.length;
    }
    if (b.isEmpty) {
      return a.length;
    }

    List<List<int>> matrix = List.generate(b.length + 1,
        (i) => List.generate(a.length + 1, (j) => j, growable: false),
        growable: false);

    for (int i = 1; i <= b.length; i++) {
      matrix[i][0] = i;
    }

    for (int i = 1; i <= b.length; i++) {
      for (int j = 1; j <= a.length; j++) {
        int substitutionCost = (a[j - 1] == b[i - 1]) ? 0 : 1;
        matrix[i][j] = _min(
          matrix[i - 1][j] + 1, // deletion
          matrix[i][j - 1] + 1, // insertion
          matrix[i - 1][j - 1] + substitutionCost, // substitution
        );
      }
    }

    return matrix[b.length][a.length];
  }

  int _min(int a, int b, int c) {
    return (a < b) ? (a < c ? a : c) : (b < c ? b : c);
  }
}
