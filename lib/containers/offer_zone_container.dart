import 'dart:math';

import 'package:findit_app/contants/discount.dart';
import 'package:findit_app/controllers/db_service.dart';
import 'package:findit_app/models/products_model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class OfferZoneContainer extends StatefulWidget {
  final String category;
  const OfferZoneContainer({
    super.key,
    required this.category,
  });

  @override
  State<OfferZoneContainer> createState() => _OfferZoneContainerState();
}

class _OfferZoneContainerState extends State<OfferZoneContainer> {
  Widget specialQuote({required int price, required int discount}) {
    int random = Random().nextInt(2);

    List<String> quotes = [
      "Special price starting at ₹$price",
      "Get discount up to $discount% off",
    ];

    return Text(
      quotes[random],
      style: const TextStyle(color: Colors.lightGreen, fontSize: 8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DbService().readProducts(widget.category),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ProductsModel> products =
              ProductsModel.fromJsonList(snapshot.data!.docs);
          if (products.isEmpty) {
            return const Center(
              child: Text("No products found."),
            );
          } else {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              color: Colors.blue.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.category.substring(0, 1).toUpperCase()}${widget.category.substring(1)}",
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/specific", arguments: {
                            "name": widget.category,
                          });
                        },
                        icon: const Icon(
                          Icons.chevron_right_rounded,
                        ),
                      ),
                    ],
                  ),
                  //show 4 products
                  Wrap(
                    children: [
                      for (int i = 0;
                          i < (products.length > 4 ? 4 : products.length);
                          i++)
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              "/view_product",
                              arguments: products[i],
                            );
                          },
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * .42,
                            height: 180,
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      products[i].image,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Text(
                                  products[i].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12),
                                ),
                                specialQuote(
                                  price: products[i].newPrice,
                                  discount: int.parse(
                                    discountPercent(
                                      products[i].oldPrice,
                                      products[i].newPrice,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  )
                ],
              ),
            );
          }
        } else {
          return Shimmer(
            gradient:
                LinearGradient(colors: [Colors.grey.shade200, Colors.white]),
            child: Container(
              height: 400,
              width: double.infinity,
              color: Colors.white,
            ),
          );
        }
      },
    );
  }
}
