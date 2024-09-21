import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findit_app/controllers/db_service.dart';
import 'package:findit_app/models/cart_model.dart';
import 'package:findit_app/models/products_model.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  StreamSubscription<QuerySnapshot>? _cartSubscription;
  StreamSubscription<QuerySnapshot>? _productSubscription;

  bool isLoading = false;

  List<CartModel> carts = [];
  List<String> cartIds = [];
  List<ProductsModel> products = [];
  int totalCost = 0;
  int totalQuantity = 0;

  CartProvider() {
    readCartData();
  }
  //Adding to cart
  void addToCart(CartModel cartModel) {
    DbService().addToCart(cartData: cartModel);
    notifyListeners();
  }

  // stream and read cart data
  void readCartData() {
    isLoading = true;
    _cartSubscription?.cancel();
    _cartSubscription = DbService().readUserCart().listen((snapshot) {
      List<CartModel> cartsData =
          CartModel.fromJsonList(snapshot.docs);

      carts = cartsData;

      cartIds = [];
      for (int i = 0; i < carts.length; i++) {
        cartIds.add(carts[i].productId);
        debugPrint("cartIds: ${cartIds[i]}");
      }
      // ignore: prefer_is_empty
      if (carts.length > 0) {
        readCartProducts(cartIds);
      }
      isLoading = false;
      notifyListeners();
    });
  }

  //read cart products
  void readCartProducts(List<String> uIds){
    _productSubscription?.cancel();
    _productSubscription = DbService().searchProducts(uIds).listen((snapshot) {
      List<ProductsModel> productsData = ProductsModel.fromJsonList(snapshot.docs);
      products = productsData;
      isLoading = false;
      addTotalCost(products, carts);
      calculateTotalQuantity();
      notifyListeners();
    },);
  }

  //Total product cost
  void addTotalCost(List<ProductsModel> products, List<CartModel> carts) {
    totalCost = 0;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        for (int i = 0; i < carts.length; i++) {
          totalCost += carts[i].quantity * products[i].newPrice;
        }
        notifyListeners();
      },
    );
  }

  //Total quantity
  void calculateTotalQuantity() {
    totalQuantity = 0;
    for (int i = 0; i < carts.length; i++) {
      totalQuantity += carts[i].quantity;
    }
    debugPrint("TotalQuantity: $totalQuantity");
    notifyListeners();
  }

    // delete product from the cart
  void deleteItem(String productId) {
    DbService().deleteItemFromCart(productId: productId);
    readCartData();
    notifyListeners();
  }

   // decrease the count of product
  void decreaseCount(String productId) async{
   await DbService().decreaseCount(productId: productId);
    notifyListeners();
  }

  void cancelProviders(){
    _cartSubscription?.cancel();
     _productSubscription?.cancel();
  }

  @override
  void dispose() {
    cancelProviders();
    super.dispose();
  }

  

}
