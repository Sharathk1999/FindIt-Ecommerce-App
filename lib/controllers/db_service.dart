import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findit_app/models/cart_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DbService {
  User? user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  //User Data
  //Add user to DB
  Future saveUserData({
    required String name,
    required String email,
  }) async {
    try {
      Map<String, dynamic> data = {
        "name": name,
        "email": email,
      };
      debugPrint("Saving $data");
      await db.collection("shop_users").doc(user!.uid).set(data);
    } catch (e) {
      debugPrint("From DbService => Error on saving user data: $e");
    }
  }

  //Update user data
  Future updateUserData({
    required Map<String, dynamic> extraData,
  }) async {
    await db.collection("shop_users").doc(user!.uid).update(extraData);
  }

  //Read the user data
  Stream<DocumentSnapshot> readUserData() {
    return db.collection("shop_users").doc(user!.uid).snapshots();
  }

  //Read all the promos and banners
  Stream<QuerySnapshot> readPromos() {
    return db.collection("shop_promos").snapshots();
  }

  Stream<QuerySnapshot> readBanners() {
    return db.collection("shop_banners").snapshots();
  }

  //Read the discount coupons
  Stream<QuerySnapshot> readDiscounts() {
    return db
        .collection("shop_coupons")
        .orderBy("discount", descending: true)
        .snapshots();
  }

  //verify the coupon
  Future<QuerySnapshot> verifyDiscountCoupon({required String code}) {
    debugPrint("searching for coupon: $code");
    return db.collection("shop_coupons").where("code", isEqualTo: code).get();
  }

  //Read All Categories
  Stream<QuerySnapshot> readCategories() {
    return db
        .collection("shop_categories")
        .orderBy("priority", descending: true)
        .snapshots();
  }

  //Products for Specific Category
  //Reading all the products
  Stream<QuerySnapshot> readProducts(String category) {
    return db
        .collection("shop_products")
        .where(
          "category",
          isEqualTo: category.toLowerCase(),
        )
        .snapshots();
  }

  //search products by doc ids
  Stream<QuerySnapshot> searchProducts(List<String> docIds) {
    return db
        .collection("shop_products")
        .where(FieldPath.documentId, whereIn: docIds)
        .snapshots();
  }

  //Reduce product quantity after purchase
  Future reduceProductQuantity({
    required String productId,
    required int quantity,
  }) async {
    await db.collection("shop_products").doc(productId).update({
      "quantity":FieldValue.increment(-quantity),
    });
  }

  //Cart
  //Reading the cart items

  Stream<QuerySnapshot> readUserCart() {
    return db
        .collection("shop_users")
        .doc(user!.uid)
        .collection("cart")
        .snapshots();
  }

  //Add to cart
  Future addToCart({required CartModel cartData}) async {
    try {
      //update the cart
      await db
          .collection("shop_users")
          .doc(user!.uid)
          .collection("cart")
          .doc(cartData.productId)
          .update({
        "product_id": cartData.productId,
        "quantity": FieldValue.increment(1)
      });
    } on FirebaseException catch (e) {
      debugPrint("Firebase exception: ${e.code}");
      if (e.code == "not-found") {
        //adding to cart
        await db
            .collection("shop_users")
            .doc(user!.uid)
            .collection("cart")
            .doc(cartData.productId)
            .set({
          "product_id": cartData.productId,
          "quantity": 1,
        });
      }
    }
  }

  //Delete specific product
  Future deleteItemFromCart({required String productId}) async {
    await db
        .collection("shop_users")
        .doc(user!.uid)
        .collection("cart")
        .doc(productId)
        .delete();
  }

  //empty user cart
  Future emptyCart() async {
    await db
        .collection("shop_users")
        .doc(user!.uid)
        .collection("cart")
        .get()
        .then(
      (value) {
        for (DocumentSnapshot docSnap in value.docs) {
          docSnap.reference.delete();
        }
      },
    );
  }

  //Decrease product count in cart
  Future decreaseCount({required productId}) async {
    //update the cart
    await db
        .collection("shop_users")
        .doc(user!.uid)
        .collection("cart")
        .doc(productId)
        .update({"quantity": FieldValue.increment(-1)});
  }

  //orders
  //new order
  Future createOrder({required Map<String, dynamic> data}) async {
    await db.collection("shop_orders").add(data);
  }

  //Update order status
  Future updateOrderStatus(
      {required String docId, required Map<String, dynamic> data}) async {
    await db.collection("shop_orders").doc(docId).update(data);
  }

  //Read order data for specific product
  Stream<QuerySnapshot> readOrders() {
    return db
        .collection("shop_orders")
        .where("user_id", isEqualTo: user!.uid)
        .orderBy("created_at", descending: true)
        .snapshots();
  }
}
