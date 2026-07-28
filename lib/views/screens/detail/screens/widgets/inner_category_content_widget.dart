import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app/controllers/subcategory_controller.dart';
import 'package:store_app/models/category_model.dart';
import 'package:store_app/models/subcategory_model.dart';
import 'package:store_app/views/screens/detail/screens/widgets/inner_banner_widget.dart';
import 'package:store_app/views/screens/detail/screens/widgets/inner_header_widget.dart';
import 'package:store_app/views/screens/detail/screens/widgets/subcategory_tile_widget.dart';

class InnerCategoryContentWidget extends StatefulWidget {
  
  final Category category;

  const InnerCategoryContentWidget({super.key, required this.category});

  @override
  State<InnerCategoryContentWidget> createState() => _InnerCategoryContentWidgetState();
}

class _InnerCategoryContentWidgetState extends State<InnerCategoryContentWidget> {
  late Future<List<SubCategoryModel>> _subcategories;
  final SubcategoryController _subcategoryController = SubcategoryController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _subcategories = _subcategoryController.getSubCategoriesByCategoryName(widget.category.name);
  }

  @override
  Widget build(BuildContext context) {
    
 
    return Scaffold(
      appBar: PreferredSize(preferredSize:Size.fromHeight(MediaQuery.of(context).size.height * 20), child: InnerHeaderWidget()),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InnerBannerWidget(image: widget.category.banner),
            Center(child: Text('Shop By Category',
            style: GoogleFonts.quicksand(
              fontSize: 20,
              fontWeight: FontWeight.bold,
          
            ),
            ),
            ),
            FutureBuilder(future: _subcategories, builder: (context,snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Hass Error ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No Categories'));
              } else {
                final subcategories = snapshot.data!;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: 
                      List.generate((subcategories.length/7).ceil(), (setIndex){
                        //for each row, calculating starting and ending indices
                        final start = setIndex * 7;
                        final end = (setIndex +1) * 7;
                         //create padding widget to add spacing around the row
                         return Padding(padding: EdgeInsets.all(8.9),
                         child: Row(
                          //Create a Row of subcategory tie
                            children:subcategories.sublist(start,end>subcategories.length ? subcategories.length:end).map((subcategory)=>SubcategoryTileWidget(image: subcategory.image, title: subcategory.subCategoryName)).toList(),
                         ),
                         );
                      }),
                    //create padding widget to add spacing around the row

                  ),
                );
              }
        }),
          ],
        ),
      ),
    );
  }
}