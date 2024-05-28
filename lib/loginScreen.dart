import 'dart:convert';
import 'package:rbgproject/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rbgproject/main.dart';
import 'package:rbgproject/register.dart';


class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _phonecontroller = TextEditingController();
  String _name = '', _phone = '';
  bool _isLoading = false;

  Future<void> loginUser() async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/login'), // replace localhost with server ip address
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': _namecontroller.text,
        'phoneNumber': _phonecontroller.text,
      }),
    );
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status']) {
      final token = jsonDecode(response.body)['token'];
      String userId = jsonResponse['data']['user']['_id'];
      // Save the token or navigate to the next screen
      print('Login successful. Token: $token');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            userId: userId,
          ),
        ),
      );
    } else {
      print('Login failed. ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width *
                        0.9, // One-third of the screen width
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.purple
                          .withOpacity(0.4), // Decreased opacity
                      borderRadius:
                      BorderRadius.circular(12.0), // Rounded corners
                    ),
                    child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10.0), // Rounded corners
                      ),
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget> [
                              TextFormField(
                                controller: _namecontroller,
                                validator: (value) => value!.isEmpty
                                    ? 'Please enter your name'
                                    : null,
                                onSaved: (value) => _name = value!,
                                style: const TextStyle(
                                  color: Colors.black, // Text color set to black
                                ),
                                decoration: const InputDecoration(
                                  labelText: 'Name',

                                  prefixIcon: Icon(Icons.person),
                                  border: OutlineInputBorder(), // Rounded border
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              TextFormField(
                                keyboardType: TextInputType.phone,
                                controller: _phonecontroller,
                                validator: (value) => value!.isEmpty
                                    ? 'Please enter your mobile number'
                                    : null,
                                onSaved: (value) => _phone = value!,
                                style: const TextStyle(
                                  color: Colors.black, // Text color set to black
                                ),
                                decoration: const InputDecoration(
                                  labelText: 'Mobile number',

                                  prefixIcon: Icon(Icons.phone),
                                  border: OutlineInputBorder(), // Rounded border
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              _isLoading
                                  ? const CircularProgressIndicator()
                                  : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      _name = _namecontroller.text;
                                      _phone = _phonecontroller.text;
                                      loginUser();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.purple, // Text color
                                    padding: const EdgeInsets.all(
                                        16.0), // Padding
                                    textStyle: const TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  child: const Text('Login'),
                                ),
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              TextButton(onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                );
                              },
                                child:
                                const Text(
                                    'Don\'t have an account, Register Now'
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}
