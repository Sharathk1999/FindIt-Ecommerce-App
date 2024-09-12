import 'package:carousel_slider/carousel_slider.dart';
import 'package:findit_app/controllers/db_service.dart';
import 'package:findit_app/models/promo_banners_model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PromoContainer extends StatefulWidget {
  const PromoContainer({super.key});

  @override
  State<PromoContainer> createState() => _PromoContainerState();
}

class _PromoContainerState extends State<PromoContainer> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DbService().readPromos(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<PromoBannersModel> promos =
              PromoBannersModel.fromJsonList(snapshot.data!.docs);
          if (promos.isEmpty) {
            return SizedBox();
          } else {
            return CarouselSlider(
              items: promos
                  .map(
                    (promo) => Image.network(promo.image,fit: BoxFit.cover,),
                  )
                  .toList(),
              options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                aspectRatio: 16/9,
                viewportFraction: 1,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
            );
          }
        } else {
          return Shimmer(
            gradient: LinearGradient(
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade600,
              ],
            ),
            child: Container(
              height: 300,
              width: double.infinity,
            ),
          );
        }
      },
    );
  }
}
