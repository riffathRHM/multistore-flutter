import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store_app/global_variables.dart';
import 'package:store_app/models/subcategory_model.dart';
import 'package:http/http.dart' as http;

class SubcategoryController {
  Future<List<SubCategoryModel>> getSubCategoriesByCategoryName(
      String categoryName) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/category/$categoryName/subcategories'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          return data
              .map((subcategory) => SubCategoryModel.fromJson(subcategory))
              .toList();
        } else {
          print('subcategories not found');
          return [];
        }
      } else if (response.statusCode == 404) {
        print('subcategories not found');
        return [];
      } else {
        print('failed to fatch categories');
        return [];
      }
    } catch (e) {
      print('Error fatching Categories= $e');
      return [];
    }
  }
}
