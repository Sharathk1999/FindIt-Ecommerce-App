import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersModel {
  String id; 
  String email; 
  String name; 
  String phone; 
  String status;
  String userId;
  String address;
  int discount, total, createdAt;
  List<OrderProductModel> products;

  OrdersModel({
    required this.id,
    required this.createdAt,
    required this.email,
    required this.name,
    required this.phone,
    required this.address,
    required this.status,
    required this.userId,
    required this.discount,
    required this.total,
    required this.products,
  });

  // convert json to object model
  factory OrdersModel.fromJson(Map<String, dynamic> json, String id) {
    return OrdersModel(
      id: id,
      createdAt: json["created_at"] ?? 0,
      email: json["email"] ?? "",
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      status: json["status"] ?? "",
      address: json["address"] ?? "",
      userId: json["user_id"] ?? "",
      discount: json["discount"] ?? 0,
      total: json["total"] ?? 0,
      products: List<OrderProductModel>.from(
        json["products"].map(
          (e) => OrderProductModel.fromJson(e),
        ),
      ),
    );
  }

// Convert List<QueryDocumentSnapshot> to List<OrdersModel>
  static List<OrdersModel> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map(
            (e) => OrdersModel.fromJson(e.data() as Map<String, dynamic>, e.id))
        .toList();
  }
}

class OrderProductModel {
  String id;
  String name;
  String image;
  int quantity;
  int singlePrice;
  int totalPrice;

  OrderProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.quantity,
    required this.singlePrice,
    required this.totalPrice,
  });

  //  convert json to object model
  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      image: json["image"] ?? "",
      quantity: json["quantity"] ?? 0,
      singlePrice: json["single_price"] ?? 0,
      totalPrice: json["total_price"] ?? 0,
    );
  }
}
