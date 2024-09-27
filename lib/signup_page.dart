import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'search_page.dart';
import 'dart:async';
import 'package:email_validator/email_validator.dart';

// Attach the EmailValidator to the TextEditingController.
// emailController.addValidator(emailValidator);


class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

const url= "10.0.0.2:5000/api/p/signup";
String responseBody = "";
Map<String, dynamic>? responseJson;

class _SignupPageState extends State<SignupPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emergencyphoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String selectedGender = "Male";

//   Future<bool> signUp(String username, String password, String email, phno, ephno, String address) async {
//     // Validate the username and password.
//     if (username.isEmpty || password.isEmpty) {
//       return false;
//     }
//     print('ok');
//     // Make the HTTP POST request.
//     final timer = Future.delayed(Duration(seconds: 10));
//     print('ok 1 ...');
//     final signUpResponse = await timer.timeout(Duration(seconds: 20), onTimeout: () async {
//       print('ok 2 .....');
//       var headers = {
//         'Content-Type': 'application/json'
//       };
//       print('ok 3..');
//       var request = http.Request('POST', Uri.parse('localhost:5000/api/p/signup'));
//       request.body = json.encode({
//         "name": username,
//         "phoneNumber": int.parse(phno),
//         "email": email,
//         "password": password,
//         "gender": selectedGender,
//         "emergencyContact": int.parse(ephno),
//         "address": address,
//       });
//       request.headers.addAll(headers);
//
//       print('ok 4 .....');
//
//       http.StreamedResponse response = await request.send();
//
//       print('ok 5 .....');
//
//       if (response.statusCode == 200) {
//         print(await response.stream.bytesToString());
//       }
//       else {
//         print(response.reasonPhrase);
//       }
//     });
//
//     print('ok 6 .....');
// // If the request times out, print a message to the console and return false.
//     if (signUpResponse == null) {
//       print('Request timed out.');
//       return false;
//     }
//
// // Check the status code of the HTTP POST response.
//     if (signUpResponse.statusCode == 200) {
//       // Successful SignUp, handle accordingly
//       return true;
//     } else {
//       // Failed SignUp, handle accordingly
//       return false;
//     }
//   }
  Future<bool> signUp(String username, String password, String email, String phno, String ephno, String address) async {
    // Validate the username and password.
    if (username.isEmpty || password.isEmpty) {
      return false;
    }

    print('ok');

    try {
      var headers = {
        'Content-Type': 'application/json'
      };

      var request = http.Request('POST', Uri.parse('https://rescueradar.onrender.com/api/p/signup'));
      request.body = json.encode({
        "name": username,
        "phoneNumber": int.parse(phno),
        "email": email,
        "password": password,
        "gender": selectedGender,
        "emergencyContact": int.parse(ephno),
        "address": address,
      });
      request.headers.addAll(headers);

      print('ok 1...');

      http.StreamedResponse response = await request.send();

      print('ok 2...');

      if (response.statusCode == 201) {
        responseBody = await response.stream.bytesToString();
        print(responseBody);
        responseJson = json.decode(responseBody);
        print('THIS IS RESPONSE BODY');
        print(responseJson);
        print(responseJson?['data']['user']['name']);
        return true; // Successful SignUp
      } else {
        print(response.reasonPhrase);
        return false; // Failed SignUp
      }
    } catch (e) {
      print("y tho # 1 ?");
      print('Error: $e');
      print("y tho?");
      return false; // Handle any exceptions as a failed SignUp
    }
  }

  bool isLoading = false;
  bool signUpSuccess = false;

  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();   // for emailvalidation can add later

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5DEB3),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/my_logo.jpg',
                  width: 100,
                  height: 100,
                ),
                SizedBox(height: 20),
                Text(
                  "Creat Your Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 30),

                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: "Username",
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "E-mail",
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // validator: (value) {
                  //   if (value!.isEmpty) {
                  //     return 'Please enter your email address';
                  //   }
                  //   if (!EmailValidator.validate(value)) {
                  //     return 'Please enter a valid email address';
                  //   }
                  //   return null;
                  // },
                ),

                SizedBox(height: 20),

                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                TextFormField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone, // This restricts the input to numbers.
                  decoration: InputDecoration(
                    hintText: "Phone Number",
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                TextFormField(
                  controller: emergencyphoneNumberController,
                  keyboardType: TextInputType.phone, // This restricts the input to numbers.
                  decoration: InputDecoration(
                    hintText: "Emergency Phone Number",
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                DropdownButtonFormField(
                  decoration: InputDecoration(
                    hintText: "Select Gender",
                    labelText: "Gender", // Specify that it is for gender selection
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  value: selectedGender,
                  items: ["Male", "Female", "Other"].map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                ),

                SizedBox(height: 20),

                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(
                    hintText: "Address",
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                SizedBox(height: 30),

                SizedBox(
                  width: 140,
                    height: 60,
                  child: ElevatedButton(
                    onPressed: () async {
                      print('Signing up...');
                      setState(() {
                        isLoading = true; // Set loading state to true
                      });
                      final username = usernameController.text;
                      final password = passwordController.text;
                      final email = emailController.text;
                      final phno = phoneNumberController.text;
                      print(phno);
                      final ephno = emergencyphoneNumberController.text;
                      print(ephno);
                      final address = addressController.text;
                      try {
                        final success = await signUp(username, password, email, phno, ephno, address);
                        // final success = true;                                           //TESTER CODE
                        if (success) {
                          print("success");
                          // Navigate to the SearchPage after a successful signup
                          final usernam = responseJson?['data']['user']['name'] as String? ?? 'default username';
                          final contat = responseJson?['data']['user']['phoneNumber'] as String? ?? '1001001001';
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(username: usernam, contact: contat)));
                        }
                        else {
                          print('Error: Signup failed.');
                          // Show a Snackbar message and allow the user to try again
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Signup Failed. Please try again."),
                          ));
                        }
                      } catch (e) {
                        // Handle signup failure (e.g., show an error message)
                        print('error: $e');
                      } finally {
                        // Set loading state to false (reset the button) in the 'finally' block
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    // Add a child to the ElevatedButton that shows a loading indicator or "Sign Up" text
                    child: isLoading
                        ? CircularProgressIndicator() // Show loading indicator
                        : Text("Sign Up",
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(5),
                      backgroundColor: Color(0xFFF02B2B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
