import 'package:findit_app/containers/banner_container.dart';
import 'package:findit_app/containers/offer_zone_container.dart';
import 'package:findit_app/controllers/db_service.dart';
import 'package:findit_app/models/category_model.dart';
import 'package:findit_app/models/promo_banners_model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomePageMainContainer extends StatefulWidget {
  const HomePageMainContainer({super.key});

  @override
  State<HomePageMainContainer> createState() => _HomePageMainContainerState();
}

class _HomePageMainContainerState extends State<HomePageMainContainer> {
  int min = 0;

  minimumCalcs(int a, int b) {
    return min = a > b ? b : a;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DbService().readCategories(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<CategoryModel> categories =
              CategoryModel.fromJsonList(snapshot.data!.docs);
          if (categories.isEmpty) {
            return const SizedBox();
          } else {
            return StreamBuilder(
              stream: DbService().readBanners(),
              builder: (context, bannerSnapshot) {
                if (bannerSnapshot.hasData) {
                  List<PromoBannersModel> banners =
                      PromoBannersModel.fromJsonList(bannerSnapshot.data!.docs);
                  if (banners.isEmpty) {
                    return const SizedBox();
                  } else {
                    return Column(
                      children: [
                        for (int i = 0;
                            i <
                                minimumCalcs(snapshot.data!.docs.length,
                                    bannerSnapshot.data!.docs.length);
                            i++)
                          Column(
                            children: [
                              OfferZoneContainer(category: snapshot.data!.docs[i]["name"]),
                              BannerContainer(category: bannerSnapshot.data!.docs[i]["category"], image: bannerSnapshot.data!.docs[i]["image"])
                            ],
                          )
                      ],
                    );
                  }
                } else {
                  return const SizedBox();
                }
              },
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
