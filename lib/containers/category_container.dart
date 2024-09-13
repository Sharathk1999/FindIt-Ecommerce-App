import 'package:findit_app/controllers/db_service.dart';
import 'package:findit_app/models/category_model.dart';
import 'package:flutter/material.dart';

class CategoryContainer extends StatefulWidget {
  const CategoryContainer({super.key});

  @override
  State<CategoryContainer> createState() => _CategoryContainerState();
}

class _CategoryContainerState extends State<CategoryContainer> {
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
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) => CategoryBtn(name: category.name, imgPath: category.image),).toList(),
              ),
            );
          }
        } else {
        return  const SizedBox();
        }
      },
    );
  }
}

class CategoryBtn extends StatefulWidget {
  final String name;
  final String imgPath;
  const CategoryBtn({
    super.key,
    required this.name,
    required this.imgPath,
  });

  @override
  State<CategoryBtn> createState() => _CategoryBtnState();
}

class _CategoryBtnState extends State<CategoryBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.all(10),
      padding:const EdgeInsets.all(10),
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(widget.imgPath,fit: BoxFit.contain,height: 50,),
        const  SizedBox(height: 5,),
          Text("${widget.name.substring(0,1).toUpperCase()}${widget.name.substring(1)}"),
        ],
      ),
    );
  }
}
