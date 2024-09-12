// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  String name;
  String email;
  String address;
  String phone;
  UserModel({
    required this.name,
    required this.email,
    required this.address,
    required this.phone,
  });

  //convert json to object model
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json["name"]??"User",
      email: json["email"]??"",
      address: json["address"]??"",
      phone: json["phone"]??"",
    );
  }
}
