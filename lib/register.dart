import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rbgproject/otp.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static String verify="";
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>with WidgetsBindingObserver {

  final _formKey = GlobalKey<FormState>();
  TextEditingController countrycode = TextEditingController();
  final TextEditingController _namecon = TextEditingController();
  final TextEditingController _phonecon = TextEditingController();
  String _name = '', _phone = '';
  String help='';
  bool _isLoading = false;
  late final Future<void> _futureloc;
  final url = 'http://localhost:3000/';
// replace localhost with server ip address
  final register = 'http://localhost:3000/registration';


  void registerUser() async{
    var regBody = {
      "name":_namecon.text,
      "phoneNumber":_phonecon.text
    };
    var response = await http.post(Uri.parse(register),
        headers: {"Content-Type":"application/json"},
        body: jsonEncode(regBody)
    );
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse['status']);
    if(jsonResponse['status']){
      String userId = jsonResponse['data']['user']['_id'];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPScreen(
              userId:userId,
              name: _namecon.text,
              mobileNumber: _phonecon.text),
        ),
      );
    }else{
      print('something went wrong');
    }
  }

  @override
  void initState() {
    super.initState();
    countrycode.text = "+91";
    WidgetsBinding.instance.addObserver(this);
    _futureloc=checkPermission(Permission.location,context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                              controller: _namecon,
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
                              controller: _phonecon,
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
                                    _name = _namecon.text;
                                    _phone = _phonecon.text;
                                    registerUser();
                                    await FirebaseAuth.instance.verifyPhoneNumber(
                                      phoneNumber: '${countrycode.text + _phone}',
                                      verificationCompleted: (PhoneAuthCredential credential) {},
                                      verificationFailed: (FirebaseAuthException e) {
                                        print("something went wrong");
                                      },
                                      codeSent: (String verificationId, int? resendToken) {
                                        HomePage.verify=verificationId;
                                        registerUser();
                                      },
                                      codeAutoRetrievalTimeout: (String verificationId) {},
                                    );

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
                                child: const Text('Register'),
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
      ),
    );
  }

  Future<void> checkPermission(Permission permission, BuildContext context) async {
    final status = await permission.request();
    print(status);
  }
}

