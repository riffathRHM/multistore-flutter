import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

void manageHttpResponse(
  {
    required http.Response response, //The HTTP response from the request
    required BuildContext context, //The BuildContext to show the dialog
    required VoidCallback onSuccess, //A callback function to execute when the response is successful

  }
){
   switch(response.statusCode){
     case 200:
     case 201: // resource created successfully
        onSuccess();
        break;
     case 400:
        final responseBody = json.decode(response.body) as Map<String, dynamic>;
        showSnackBar(context, responseBody['msg']?.toString() ?? responseBody['message']?.toString() ?? 'Bad request');
        break;
     case 500:
        final responseBody = json.decode(response.body) as Map<String, dynamic>;
        showSnackBar(context, responseBody['error']?.toString() ?? 'Server error');
        break;
     default:
        showSnackBar(context, 'Unexpected error: ${response.statusCode}');
   }
}

void showSnackBar(BuildContext context , String title){
  ScaffoldMessenger.of( context).showSnackBar(SnackBar(content: Text(title)));
}