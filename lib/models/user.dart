import 'dart:convert';

class User {
  //Define the fields of the User class
   final String id;
   final String fullName;
   final String email;
   final String state;
   final String city;
   final String locality;
   final String password;

  User({required this.id, required this.fullName, required this.email, required this.state, required this.city, required this.locality, required this.password});
  //Serialization:convert user object to a map
  //Map : A Map is a collection of key-value pairs, where each key is unique and maps to a specific value. In Dart, you can use the Map class to create and manipulate maps.
  Map<String , dynamic > toMap() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'email': email,
      'state': state,
      'city': city,
      'locality': locality,
      'password': password
    };  
  }

  //serialization:convert map to a json string
  //This method directly converts the User object to a JSON string
  //The json.encode() function convert a Dart pbject 
  String toJson() => json.encode(toMap());

  //Deserialization:convert a map to a user object
  //purpose - Manipulation and user: Once the data is converted to a map
  // the factory constructor fromMap is used to create a User object from the map. This allows you to easily manipulate the data as a User object 
  //fromMap - this constructor take a map<String, dynamic> and convert into a user object 
  // its useful when you alrady have the data in map format 

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] as String? ?? "", // Handle null case for id
      fullName: map['fullName'] as String? ?? "",
      email: map['email'] as String? ?? "", 
      state: map['state'] as String? ?? "", // Handle null case for state
      city: map['city'] as String? ?? "", // Handle null case for city
      locality: map['locality'] as String? ?? "", // Handle null case for locality
      password: map['password'] as String? ?? "" // Handle null case for password
    );
  }

  factory User.formJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);
}
