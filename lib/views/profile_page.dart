// ignore_for_file: use_build_context_synchronously

import 'package:findit_app/controllers/auth_service.dart';
import 'package:findit_app/providers/cart_provider.dart';
import 'package:findit_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Consumer<UserProvider>(
              builder: (context, user, child) => Card(
                child: ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  trailing: const Icon(Icons.edit),
                  onTap: () {
                    Navigator.pushNamed(context, "/update_profile");
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              title: const Text("Orders"),
              leading: const Icon(Icons.local_shipping_rounded),
              onTap: () {
                Navigator.pushNamed(context, "/orders");
              },
            ),
            const Divider(
              thickness: 1,
              endIndent: 10,
              indent: 10,
            ),
            ListTile(
              title: const Text("Discount & Offers"),
              leading: const Icon(
                Icons.discount_rounded,
              ),
              onTap: () {
                Navigator.pushNamed(context, "/discount");
              },
            ),
            const Divider(
              thickness: 1,
              endIndent: 10,
              indent: 10,
            ),
            ListTile(
              title: const Text("Help & Support"),
              leading: const Icon(Icons.support_agent_rounded),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Contact as at helpdeskfindit@gmail.com,",
                    ),
                  ),
                );
              },
            ),
            const Divider(
              thickness: 1,
              endIndent: 10,
              indent: 10,
            ),
            ListTile(
              title: const Text("Logout"),
              leading: const Icon(Icons.logout_rounded),
              onTap: () async {
                Provider.of<UserProvider>(context,listen: false).cancelProviders();
                Provider.of<CartProvider>(context,listen: false).cancelProviders();
                await AuthService().logOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/login",
                  (route) => true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
