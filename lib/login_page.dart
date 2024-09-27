import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'search_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

String responseBody = "";
Map<String, dynamic>? responseJson;

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //
  Future<bool> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return false;
    }
    try {
      var headers = {
        'Content-Type': 'application/json'
      };

      var request = http.Request(
          'POST', Uri.parse('https://rescueradar.onrender.com/api/p/login'));
      request.body = json.encode({
        "email": email,
        "password": password,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        responseBody = await response.stream.bytesToString();
        print(responseBody);
        responseJson = json.decode(responseBody);
        print('THIS IS RESPONSE BODY');
        print(responseJson);
        print(responseJson?['data']['user']['name']);
        return true;
      }
      else {
        print(response.reasonPhrase);
        return false;
      };
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  bool isLoading = false;
  bool signUpSuccess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5DEB3),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                "Enter login deatils",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
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
              SizedBox(
                width: 140,
                  height: 60,
                child: ElevatedButton(
                  onPressed: () async {
                    print('logging in...');
                    setState(() {
                      isLoading = true; // Set loading state to true
                    });
                    final email = emailController.text;
                    final password = passwordController.text;
                    try {
                      final success = await login(email, password);
                      // final success = true;                              //TESTER CODE

                      if (success) {
                        print("success");
                        // Navigate to the SearchPage after a successful signup
                        final usernam = responseJson?['data']['user']['name'] as String? ?? 'default username';
                        final contat = responseJson?['data']['user']['phoneNumber'] as String? ?? '1001001001';
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(username: usernam, contact: contat)));
                      }
                      else {
                        print('Error: Login failed.');
                        // Show a Snackbar message and allow the user to try again
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Login Failed. Please try again."),
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
                      : Text("Login",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
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
    );
  }
}
