import 'package:findit_app/providers/cart_provider.dart';
import 'package:findit_app/views/cart_page.dart';
import 'package:findit_app/views/home_page.dart';
import 'package:findit_app/views/orders_page.dart';
import 'package:findit_app/views/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeNavBar extends StatefulWidget {
  const HomeNavBar({super.key});

  @override
  State<HomeNavBar> createState() => _HomeNavBarState();
}

class _HomeNavBarState extends State<HomeNavBar> {
  int selectedIndex = 0;

  List pages = const [
    HomePage(),
    OrdersPage(),
    CartPage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex=value;
          });
        },
        selectedItemColor: Colors.blue ,
        unselectedItemColor: Colors.blueGrey.shade100,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.local_shipping_rounded,
            ),
            label: "Orders",
          ),
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(
              builder: (context, value, child) {
                if (value.carts.length > 0) {
                  return Badge(
                    label: Text(value.carts.length.toString()),
                    child: Icon(Icons.shopping_cart_outlined),
                  );
                }
                return Icon(Icons.shopping_cart_outlined);
              },
             
              
            ),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outlined,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
