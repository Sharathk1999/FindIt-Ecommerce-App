// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findit_app/contants/payments.dart';
import 'package:findit_app/controllers/db_service.dart';
import 'package:findit_app/providers/cart_provider.dart';
import 'package:findit_app/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _couponController = TextEditingController();

  int discount = 0;
  int toPay = 0;
  String discountText = "";

  bool paymentSuccess = false;
  Map<String, dynamic> dataOfOrder = {};

  discountCalculator(int disPercent, int totalCost) {
    discount = (disPercent * totalCost) ~/ 100;
    setState(() {});
  }

  Future<void> initPaymentSheet(int cost) async {
    try {
      final user = Provider.of<UserProvider>(context, listen: false);
      // 1. create payment intent on the server
      final data = await createPaymentIntent(
          name: user.name,
          address: user.address,
          amount: (cost * 100).toString());

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'Flutter Stripe Store Demo',
          paymentIntentClientSecret: data['client_secret'],
          // Customer keys
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['id'],
          // Extra options

          style: ThemeMode.dark,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _couponController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Checkout",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        child: Consumer<UserProvider>(
          builder: (context, userData, child) => Consumer<CartProvider>(
            builder: (context, cartData, child) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Delivery Details",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .65,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userData.name,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(userData.email),
                                Text(userData.address),
                                Text(userData.phone),
                              ],
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/update_profile");
                            },
                            icon: const Icon(
                              CupertinoIcons.pencil_ellipsis_rectangle,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Do you have a coupon?"),
                    Row(
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            textCapitalization: TextCapitalization
                                .characters, // capitalize first letter of each word
                            controller: _couponController,
                            decoration: InputDecoration(
                              labelText: "Coupon Code",
                              hintText: "Enter Coupon for extra discount",
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.grey.shade200,
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: () async {
                              QuerySnapshot querySnapshot = await DbService()
                                  .verifyDiscountCoupon(
                                      code:
                                          _couponController.text.toUpperCase());

                              if (querySnapshot.docs.isNotEmpty) {
                                QueryDocumentSnapshot doc =
                                    querySnapshot.docs.first;
                                String code = doc.get('code');
                                int percent = doc.get('discount');

                                // access other fields as needed
                                debugPrint('Discount code: $code');
                                discountText =
                                    "Discount of $percent% has been applied.";
                                discountCalculator(percent, cartData.totalCost);
                              } else {
                                debugPrint('No discount code found');
                                discountText = "No discount code found";
                              }
                              setState(() {});
                            },
                            child: const Text("Apply"))
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    discountText == "" ? Container() : Text(discountText),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Total Quantity of Products: ${cartData.totalQuantity}",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Sub Total: ₹ ${cartData.totalCost}",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const Divider(),
                    Text(
                      "Extra Discount: - ₹ $discount",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Divider(),
                    Text(
                      "Total Payable: ₹ ${cartData.totalCost - discount}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () async {
            final user = Provider.of<UserProvider>(context, listen: false);
            if (user.address == "" ||
                user.phone == "" ||
                user.name == "" ||
                user.email == "") {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Please fill your delivery details.")));
              return;
            }

            await initPaymentSheet(
                Provider.of<CartProvider>(context, listen: false).totalCost -
                    discount);

            try {
              await Stripe.instance.presentPaymentSheet();

              final cart = Provider.of<CartProvider>(context, listen: false);
              User? currentUser = FirebaseAuth.instance.currentUser;
              List products = [];

              for (int i = 0; i < cart.products.length; i++) {
                products.add({
                  "id": cart.products[i].id,
                  "name": cart.products[i].name,
                  "image": cart.products[i].image,
                  "single_price": cart.products[i].newPrice,
                  "total_price":
                      cart.products[i].newPrice * cart.carts[i].quantity,
                  "quantity": cart.carts[i].quantity,
                });
              }

              // ORDER STATUS
              // PAID - Paid by the user
              // SHIPPED - Product Shipped
              // CANCELLED - Product Cancelled
              // DELIVERED - Order Delivered

              Map<String, dynamic> orderData = {
                "user_id": currentUser!.uid,
                "name": user.name,
                "email": user.email,
                "address": user.address,
                "phone": user.phone,
                "discount": discount,
                "total": cart.totalCost - discount,
                "products": products,
                "status": "PAID",
                "created_at": DateTime.now().millisecondsSinceEpoch,
              };

              await DbService().createOrder(data: orderData);

              //Looping over to get all the product id and reduce the quantity
              for (int i = 0; i < cart.products.length; i++) {
                DbService().reduceProductQuantity(productId: cart.products[i].id, quantity: cart.carts[i].quantity);
              }
              //clear the user after payment
              await DbService().emptyCart();
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                  "Payment Done",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green,
              ));
            } catch (e) {
              debugPrint("payment sheet error : $e");
              debugPrint("payment sheet failed");
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                  "Payment Failed",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.redAccent,
              ));
            }
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5))),
          child: const Text("Proceed to pay"),
        ),
      ),
    );
  }
}
