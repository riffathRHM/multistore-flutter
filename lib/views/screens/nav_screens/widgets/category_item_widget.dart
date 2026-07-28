import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app/controllers/category_controller.dart';
import 'package:store_app/models/category_model.dart';
import 'package:store_app/views/screens/detail/screens/inner_category_screen.dart';
import 'package:store_app/views/screens/nav_screens/widgets/reusable_text_widget.dart';

class CategoryItemWidget extends StatefulWidget {
  const CategoryItemWidget({super.key});

  @override
  State<CategoryItemWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryItemWidget> {
  late Future<List<Category>>futureCategories;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCategories = CategoryController().loadCategories();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       const  ReusableTextWidget(title: 'Categories', subtitle: 'View All'),
        FutureBuilder(future: futureCategories, builder: (context,snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Hass Error ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No Categories'));
              } else {
                final categories = snapshot.data!;
                return GridView.builder(
                  physics:  const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                    itemCount: categories.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, crossAxisSpacing: 8, mainAxisSpacing: 8),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return InnerCategoryScreen(category: category,);
                          }));
                        },
                        child: Column(
                          children: [
                            Image.network(
                                category.image,
                                width: 47,
                                height: 47,
                              ),
                              Text(category.name,style:GoogleFonts.quicksand(fontWeight: FontWeight.bold,fontSize: 15)),
                          ],
                        ),
                      );
                    }
                );
              }
        }),
      ],
    );
  }
}