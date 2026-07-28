import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app/controllers/category_controller.dart';
import 'package:store_app/controllers/subcategory_controller.dart';
import 'package:store_app/models/category_model.dart';
import 'package:store_app/models/subcategory_model.dart';
import 'package:store_app/views/screens/detail/screens/widgets/subcategory_tile_widget.dart';
import 'package:store_app/views/screens/nav_screens/widgets/header_widget.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<List<Category>> futureCategories;
  Category? _selectedCategory;
  List<SubCategoryModel> _subcategories = [];
  final SubcategoryController _subcategoryController = SubcategoryController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCategories = CategoryController().loadCategories();
    futureCategories.then((categories) {
      // if (mounted && categories.isNotEmpty) {
      //   setState(() {
      //     _selectedCategory = categories.first;
      //     _loadSubCategories(categories.first.name);
      //   });
      // }
      for (var category in categories) {
        if (category.name == 'Fashion') {
          setState(() {
            _selectedCategory = category;
          });
          _loadSubCategories(category.name);
        }
      }
    });
  }

  // this function load the subcatgories based on category name
  Future<void> _loadSubCategories(String categoryName) async {
    final subcategories = await _subcategoryController
        .getSubCategoriesByCategoryName(categoryName);
    setState(() {
      _subcategories = subcategories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 20),
          child: HeaderWidget()),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Left side display category
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey.shade200,
              child: FutureBuilder(
                  future: futureCategories,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('Hass Error ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No Categories'));
                    } else {
                      final categories = snapshot.data!;
                      return ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return ListTile(
                              onTap: () {
                                setState(() {
                                  _selectedCategory = category;
                                });
                                _loadSubCategories(category.name);
                              },
                              title: Text(
                                category.name,
                                style: GoogleFonts.quicksand(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _selectedCategory == category
                                      ? Colors.blue
                                      : Colors.black,
                                ),
                              ),
                            );
                          });
                    }
                  }),
            ),
          ),
          //Right side - Display selected category details
          Expanded(
            flex: 5,
            child: _selectedCategory != null
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _selectedCategory!.name,
                            style: GoogleFonts.quicksand(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.7,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        NetworkImage(_selectedCategory!.banner),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                        _subcategories.isNotEmpty
                            ? GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _subcategories.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 4,
                                        crossAxisSpacing: 8,
                                        childAspectRatio: 2/3
                                        ),
                                itemBuilder: (context, index) {
                                  final subcategory = _subcategories[index];
                                  return SubcategoryTileWidget(image: subcategory.image, title: subcategory.subCategoryName);
                                })
                            : Center(child: Text('No Sub Categories'))
                      ],
                    ),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
