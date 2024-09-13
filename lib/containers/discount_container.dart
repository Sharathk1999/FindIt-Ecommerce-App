import 'package:findit_app/controllers/db_service.dart';
import 'package:findit_app/models/coupon_model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DiscountContainer extends StatefulWidget {
  const DiscountContainer({super.key});

  @override
  State<DiscountContainer> createState() => _DiscountContainerState();
}

class _DiscountContainerState extends State<DiscountContainer> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DbService().readDiscounts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<CouponModel> discounts =
              CouponModel.fromJsonList(snapshot.data!.docs);

          if (discounts.isEmpty) {
            return SizedBox();
          } else {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 20,
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.blue.shade700,
                    highlightColor: Colors.grey.shade300,
                   loop: 10,
                    child: Text(
                      "Use coupon: ${discounts[0].code}",
                      style: TextStyle(color: Colors.blue.shade700,fontWeight: FontWeight.bold,),
                    ),
                  ),
                  Text(
                    discounts[0].description,
                    style: TextStyle(color: Colors.blue.shade700,),
                  ),
                ],
              ),
            );
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
