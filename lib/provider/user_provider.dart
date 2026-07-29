
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/models/user.dart';

class UserProvider extends StateNotifier<User?>{
   //constructor initializing with default user object
   //manage the state of the user object allowing objects

   UserProvider():super(User(id: '', fullName: '', email: '', state: '', city: '', locality: '', password: '', token: ''));

   //Getter method to extract value from the object
   User? get user => state;
   //method to set user state from json
   //purpose: update the user status based on Json String representaion of user object 
   void setUser(String userJson){
     state = User.formJson(userJson);
   }

   //method to clear user state
   void signOut() {
     state = null;
   }
   
}
//make the data accesable within the app
   final userProvider = StateNotifierProvider<UserProvider,User?>((ref) => UserProvider());