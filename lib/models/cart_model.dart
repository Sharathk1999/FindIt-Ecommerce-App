// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  final String productId;
  int quantity;
  CartModel({
    required this.productId,
    required this.quantity,
  });

  //convert json to object model
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      productId: json["product_id"] ?? "",
      quantity: json["quantity"] ?? 0,
    );
  }

  //convert List<QueryDocSnap> to List<CartModel>
  static List<CartModel> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map(
          (e) => CartModel.fromJson(e.data() as Map<String, dynamic>),
        )
        .toList();
  }

}
