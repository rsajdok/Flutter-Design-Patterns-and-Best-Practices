import 'package:candy_store/common/common.dart';
import 'package:candy_store/product/domain/model/product_list_item.dart';
import 'package:candy_store/product/domain/repository/product_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final IProductRepository _productRepository;

  ProductsBloc(this._productRepository) : super(const ProductsState()) {
    on<ProductsFetched>(_onProductsFetched);
    on<ProductsSearched>(_onProductsSearched);
  }

  Future<void> _onProductsFetched(
    ProductsFetched event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      emit(state.copyWith(loadingResult: const DelayedResult.inProgress()));
      final products = await _productRepository.getProducts();
      emit(
        state.copyWith(
          items: products
              .map(
                (p) => ProductListItem(
                  id: p.id,
                  name: p.name,
                  description: p.description,
                  price: p.price,
                  imageUrl: p.imageUrl,
                ),
              )
              .toList(),
        ),
      );
      emit(state.copyWith(loadingResult: const DelayedResult.none()));
    } on Exception catch (ex) {
      emit(state.copyWith(loadingResult: DelayedResult.fromError(ex)));
    }
  }

  Future<void> _onProductsSearched(
    ProductsSearched event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      emit(state.copyWith(loadingResult: const DelayedResult.inProgress()));
      final products = await _productRepository.searchProducts(event.query);
      emit(
        state.copyWith(
          items: products
              .map(
                (p) => ProductListItem(
                  id: p.id,
                  name: p.name,
                  description: p.description,
                  price: p.price,
                  imageUrl: p.imageUrl,
                ),
              )
              .toList(),
        ),
      );
      emit(state.copyWith(loadingResult: const DelayedResult.none()));
    } on Exception catch (ex) {
      emit(state.copyWith(loadingResult: DelayedResult.fromError(ex)));
    }
  }
}

class ProductsState extends Equatable {
  final List<ProductListItem> items;
  final DelayedResult<void> loadingResult;

  const ProductsState({
    this.loadingResult = const DelayedResult.none(),
    this.items = const [],
  });

  @override
  List<Object?> get props => [items, loadingResult];

  ProductsState copyWith({
    List<ProductListItem>? items,
    DelayedResult<void>? loadingResult,
  }) {
    return ProductsState(
      items: items ?? this.items,
      loadingResult: loadingResult ?? this.loadingResult,
    );
  }
}

sealed class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

final class ProductsFetched extends ProductsEvent {
  const ProductsFetched();
}

final class ProductsSearched extends ProductsEvent {
  const ProductsSearched(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}
