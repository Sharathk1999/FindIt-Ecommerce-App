import 'package:findit_app/containers/category_container.dart';
import 'package:findit_app/containers/discount_container.dart';
import 'package:findit_app/containers/home_page_main_container.dart';
import 'package:findit_app/containers/promo_container.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(
          "FindIt Top Deals",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body:const SingleChildScrollView(
        child: Column(
          children: [
            PromoContainer(),
            DiscountContainer(),
            CategoryContainer(),
            HomePageMainContainer()
          ],
        ),
      ),
    );
  }
}
