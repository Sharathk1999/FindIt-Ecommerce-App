// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String id;
  String name;
  String image;
  int priority;
  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.priority,
  });

  //convert json to object model
  factory CategoryModel.fromJson(Map<String, dynamic> json, String id) {
    return CategoryModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      image: json["image"] ?? "",
      priority: json["priority"] ?? "",
    );
  }

  //convert List<QueryDocSnap> to List<CategoryModel>
  static List<CategoryModel> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map(
          (e) => CategoryModel.fromJson(e.data() as Map<String, dynamic>, e.id),
        )
        .toList();
  }
}
