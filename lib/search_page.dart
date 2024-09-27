import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'custom_button.dart';
import 'dart:convert';
import 'show_page.dart';

class SearchPage extends StatefulWidget {
  String username = '';
  String contact = '';
  SearchPage({required this.username, required this.contact});
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isWaiting = false; // A flag to track if it's in a waiting state.
  bool isTimeout = false; // A flag to track if a timeout occurred.

  // Function to reset the state and animation to the initial button state.
  void resetState() {
    setState(() {
      isWaiting = false;
      isTimeout = false;
    });
  }

  Future<String?> fetchDataFromAPI() async {
    try {
      final response = await http.get(
        Uri.parse('http://your-nodejs-backend-url/your-api-endpoint'),
      ).timeout(Duration(seconds: 10)); // Add a timeout of 10 seconds.

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null; // Return null in case of an error.
      }
    } catch (e) {
      return null; // Return null in case of an error.
    }
  }

  Future<bool> startAPICall() async {
    final Map<String, dynamic> requestBody = {
      "name": "John Doe",
      "phoneNumber": "123457890",
      "latitude": 12.8996000289917,
      "longitude": 80.22090148925781,
    };

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
      'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2vySWQiOiIxODc4ZDI3ZS1jZTYzLTQ4MTEtOTFlNi0xZTlkN2A5ZTExMmUiLCJpYXQiOjE2OTg5NzU4NTUsImV4cCI6MTY5OTA2MjI1NX0.9gOnZz8m3EBm5LiXkrjJbBKsBRwifQUzcbFyipsCg5E',
    };

    try {
      final response = await http.post(
        Uri.parse('https://rescuerr.onrender.com/api/request'),
        headers: headers,
        body: jsonEncode(requestBody), // Convert the map to JSON
      );

      if (response.statusCode == 200) {
        // API call succeeded, handle the response here.
        print('success');
        Navigator.push(context, MaterialPageRoute(builder: (context) => ShowPage()));
        return true;
      } else {
        // API request failed, show a snackbar and reset the animation.
        print('Error: Request failed.');
        showSnackbar("API Request Failed");
        resetState();
        return false;
      }
    } catch (e) {
      // Handle any exceptions that occur during the API call.
      print('Error: $e');
      showSnackbar("API Request Failed");
      resetState();
      return false;
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Contact Info',
                style: TextStyle(
                  color: Color(0xFFF5DEB3),
                  fontSize: 24,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(
                'name: ${widget.username}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(
                'contact: ${widget.contact}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Visibility(
                  visible: !isWaiting && !isTimeout,
                  child: Container(
                    width: 100,
                    height: 100,
                    child: ElevatedButton(
                      onPressed: () async {
                        print('Requesting...');
                        setState(() {
                          isWaiting = true;
                        });
                        try {
                          final success = await startAPICall();
                          if (!success) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("API Request Failed. Please try again."),
                            ));
                          }
                        } catch (e) {
                          print('error: $e');
                        } finally {
                          setState(() {
                            isWaiting = false;
                          });
                        }
                      },
                      child: Text('SOS',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        backgroundColor: Color(0xFFF02B2B),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isWaiting,
                  child: Container(
                    width: 350,
                    height: 350,
                    child: RipplesAnimation(
                      size: 80.0,
                      color: Color(0xFFF02B2B),
                      onPressed: () {},
                      child: Text("Loading..."),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
