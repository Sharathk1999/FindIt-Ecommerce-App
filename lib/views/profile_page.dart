import 'package:findit_app/controllers/auth_service.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile Page",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              title: Text("Test User"),
            ),
          ),
          ListTile(
            title: Text("Logout"),
            onTap: ()async {
              await AuthService().logOut();
              Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => true,);
            },
          )
        ],
      ),
    );
  }
}
