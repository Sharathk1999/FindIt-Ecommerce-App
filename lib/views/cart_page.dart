import 'package:findit_app/containers/cart_container.dart';
import 'package:findit_app/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int count = 1;
  int totalCost = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cart",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
      ),
      body: Consumer<CartProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (value.products.isNotEmpty) {
              return ListView.builder(
                itemCount: value.carts.length,
                itemBuilder: (context, index) {
                  return CartContainer(
                    name: value.products[index].name,
                    image: value.products[index].image,
                    productId: value.products[index].id,
                    newPrice: value.products[index].newPrice,
                    oldPrice: value.products[index].oldPrice,
                    maxQuantity: value.products[index].maxQuantity,
                    selectedQuantity: value.carts[index].quantity,
                  );
                },
              );
            } else {
              return const Center(child: Text("No items in cart."));
            }
          }
        },
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, value, child) {
          if (value.carts.isEmpty) {
            return const SizedBox();
          } else {
            return Container(
              width: double.infinity,
              height: 60,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total: ₹${value.totalCost}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      "Proceed to Checkout",
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
