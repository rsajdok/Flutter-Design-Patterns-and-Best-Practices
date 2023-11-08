import 'package:candy_store/cart_info.dart';
import 'package:candy_store/cart_list_item.dart';
import 'package:candy_store/product_list_item.dart';

abstract class ICartRepository {
  Stream<CartInfo> get cartInfoStream;
  Future<CartInfo> get cartInfoFuture;
  Future<void> addToCart(ProductListItem item);
  Future<void> removeFromCart(CartListItem item);
}
