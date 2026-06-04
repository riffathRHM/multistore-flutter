import 'package:store_app/global_variables.dart';
import 'package:store_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/services/manage_http_response.dart';

class AuthController {
  //Future - function  will take some time to execute
  Future<void>signUpUsers({
    required context,
    required String email,
    required String fullName,
    required String password,
  })async{
   try {
    User user = User(id:'',fullName: fullName, email: email, state: '', locality: '', city: '', password: password);
   http.Response response = await http.post(Uri.parse('$uri/api/signup'), 
    body:user.toJson(),
    headers: <String, String>{ //set the headers for the request
      'Content-Type': 'application/json; charset=UTF-8', // This header indicates that the body of the request is in JSON format and uses UTF-8 character encoding
    },
    ); // convert the user object to json
    manageHttpResponse(response: response, context: context, onSuccess: (){
      showSnackBar(context, 'Account has been created successfully');
    });
   } catch(e) {
      showSnackBar(context, e.toString());
   }
  }
}