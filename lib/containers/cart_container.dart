// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_unnecessary_containers, sized_box_for_whitespace
import 'package:findit_app/contants/discount.dart';
import 'package:findit_app/models/cart_model.dart';
import 'package:findit_app/providers/cart_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartContainer extends StatefulWidget {
  final String name;
  final String image;
  final String productId;
  final int newPrice;
  final int oldPrice;
  final int maxQuantity;
  final int selectedQuantity;
  const CartContainer({
    super.key,
    required this.name,
    required this.image,
    required this.productId,
    required this.newPrice,
    required this.oldPrice,
    required this.maxQuantity,
    required this.selectedQuantity,
  });

  @override
  State<CartContainer> createState() => _CartContainerState();
}

class _CartContainerState extends State<CartContainer> {
  int count = 1;

  

  incrementCount(int max) {
    if (count >= max) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "You have reached the maximun quantity.",
          ),
        ),
      );
      return;
    } else {
      Provider.of<CartProvider>(context, listen: false).addToCart(
        CartModel(
          productId: widget.productId,
          quantity: count,
        ),
      );
      setState(() {
        count++;
      });
    }
  }

  decreaseCount() {
    if (count > 1) {
      Provider.of<CartProvider>(context, listen: false)
          .decreaseCount(widget.productId);
      setState(() {
        count--;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    count=widget.selectedQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  child: Image.network(widget.image),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          widget.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            "₹${widget.oldPrice}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "₹${widget.newPrice}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.arrow_drop_down_outlined,
                            color: Colors.lightGreen,
                          ),
                          Text(
                            "${discountPercent(widget.oldPrice, widget.newPrice)}%",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.lightGreen,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false)
                        .deleteItem(widget.productId);
                  },
                  icon: Icon(
                    CupertinoIcons.delete,
                    color: Colors.redAccent.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text(
                  "Quantity:",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
               const SizedBox(
                  width: 5,
                ),
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(onPressed: () {
                    incrementCount(widget.maxQuantity);
                  }, icon:const Icon(Icons.add,),),
                ),
                 const SizedBox(
                  width: 5,
                ),
                Text("${widget.selectedQuantity}", style:const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),),
                 const SizedBox(
                  width: 5,
                ),
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(onPressed: () {
                    decreaseCount();
                    setState(() {
                      
                    });
                  }, icon:const Icon(Icons.remove,),),
                ),
                const SizedBox(width: 5,),
                const Spacer(),
                const Text("Total:"),
                const SizedBox(width: 5,),
                Text("₹${widget.newPrice * count}", style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),)

              ],
            )
          ],
        ),
      ),
    );
  }
}
