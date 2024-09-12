// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsModel {
  String name;
  String description;
  String image;
  int oldPrice;
  int newPrice;
  String category;
  String id;
  int maxQuantity;
  ProductsModel({
    required this.name,
    required this.description,
    required this.image,
    required this.oldPrice,
    required this.newPrice,
    required this.category,
    required this.id,
    required this.maxQuantity,
  });

  factory ProductsModel.fromJson(Map<String, dynamic> json, String id) {
    return ProductsModel(
      name: json["name"] ?? "",
      description: json["description"]?? "no description",
      image: json["image"]?? "",
      oldPrice: json["oldPrice"]?? 0,
      newPrice: json["newPrice"]?? 0,
      category: json["category"]?? "",
      id: id,
      maxQuantity: json["quantity"]?? 0,
    );
  }

    //convert List<QueryDocSnap> to List<ProductsModel>
  static List<ProductsModel> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map(
          (e) => ProductsModel.fromJson(e.data() as Map<String, dynamic>, e.id),
        )
        .toList();
  }
}
