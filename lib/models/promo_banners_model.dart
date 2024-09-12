import 'package:cloud_firestore/cloud_firestore.dart';

class PromoBannersModel {
  final String id;
  final String title;
  final String image;
  final String category;

  PromoBannersModel({
    required this.id,
    required this.title,
    required this.image,
    required this.category,
  });

    //convert json to object model
  factory PromoBannersModel.fromJson(Map<String, dynamic> json, String id) {
    return PromoBannersModel(
      id: id,
      title: json["title"] ?? "",
      image: json["image"] ?? "",
      category: json["category"] ?? "",
    );
  }

  //convert List<QueryDocSnap> to List<PromoBannersModel>
  static List<PromoBannersModel> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map(
          (e) => PromoBannersModel.fromJson(e.data() as Map<String, dynamic>, e.id),
        )
        .toList();
  }
}
