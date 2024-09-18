import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BannerContainer extends StatefulWidget {
  final String category;
  final String image;
  const BannerContainer({
    super.key,
    required this.category,
    required this.image,
  });

  @override
  State<BannerContainer> createState() => _BannerContainerState();
}

class _BannerContainerState extends State<BannerContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/specific", arguments: {
          "name": widget.category,
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 200,
        child: CachedNetworkImage(
          imageUrl: widget.image,
          placeholder: (context, url) =>
              const Center(child:  CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
 