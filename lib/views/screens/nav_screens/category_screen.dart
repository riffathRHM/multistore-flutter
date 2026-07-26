import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app/controllers/category_controller.dart';
import 'package:store_app/models/category_model.dart';
import 'package:store_app/views/screens/nav_screens/widgets/header_widget.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<List<Category>> futureCategories;
  Category? _selectedCategory;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCategories = CategoryController().loadCategories();
    futureCategories.then((categories) {
      if (mounted && categories.isNotEmpty) {
        setState(() {
          _selectedCategory = categories.first;
        });
      }
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
                ? Column(
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
                    ],
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
