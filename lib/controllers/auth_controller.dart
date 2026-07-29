import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/global_variables.dart';
import 'package:store_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/provider/user_provider.dart';
import 'package:store_app/services/manage_http_response.dart';
import 'package:store_app/views/screens/authentication_screens/login_screen.dart';
import 'package:store_app/views/screens/main_screen.dart';

final providerContainer = ProviderContainer();

class AuthController {
  //Future - function  will take some time to execute
  Future<void> signUpUsers({
    required context,
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      User user = User(
          id: '',
          fullName: fullName,
          email: email,
          state: '',
          locality: '',
          city: '',
          password: password,
          token: ''); // create a user object with the provided details
      http.Response response = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          //set the headers for the request
          'Content-Type':
              'application/json; charset=UTF-8', // This header indicates that the body of the request is in JSON format and uses UTF-8 character encoding
        },
      ); // convert the user object to json
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
            showSnackBar(context, 'Account has been created successfully');
          });
    } catch (e) {
      print('Error: $e');
    }
  }

  ///sign in users function
  Future<void> signInUsers(
      {required context,
      required String email,
      required String password}) async {
    try {
      http.Response response = await http.post(Uri.parse("$uri/api/signin"),
          body: jsonEncode(
            {'email': email, 'password': password},
          ),
          headers: <String, String>{
            'Content-Type':
                'application/json; charset=UTF-8', //tell the sever how the text is encoding
          });
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () async {
            //Access sharedprefernece for token and user data storage
            SharedPreferences Preferences =
                await SharedPreferences.getInstance();
            //extract auth token from response body
            String token = jsonDecode(response.body)['token'];
            //STORE the authentiction token safly in sharedprerences
            await Preferences.setString('auth_token', token);
            //encode user data recived from backend as json
            final userJson = jsonEncode(jsonDecode(response.body)['user']);
            //Update the application state with the user data using Riverpod
            providerContainer.read(userProvider.notifier).setUser(userJson);
            //store the data in sharepreferences for future use
            await Preferences.setString('user', userJson);

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
                (route) => false);
            showSnackBar(context, 'Login successful');
          });
    } catch (e) {
      print('Error: $e');
    }
  }

  ////Sign out
  Future<void> signOutUser({required context}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      //clear the token and user from SharedPreferences
      await preferences.remove('auth_token');
      await preferences.remove('user');
      //clear the user state
      providerContainer.read(userProvider.notifier).signOut();
      //navigate to the login screen
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return LoginScreen();
      }), (route) => false);

      showSnackBar(context, 'Sign out successfully');
    } catch (e) {
      showSnackBar(context, 'Error signing out');
    }
  }
}
