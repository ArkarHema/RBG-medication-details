import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import "dart:convert";
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rbgproject/loginScreen.dart';
import 'package:rbgproject/main.dart';
import 'package:rbgproject/register.dart';

class OTPScreen extends StatefulWidget {
  final String userId;
  final String name;
  final String mobileNumber;
  const OTPScreen({super.key, required this.userId, required this.name, required this.mobileNumber});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController otpController = TextEditingController();
  var code="";


  @override
  void initState() {
    super.initState();
    // Automatically set the OTP when it's received
    otpController.text = HomePage.verify;
    code = HomePage.verify;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            Text(
              'OTP Verification ${widget.name}',
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                        controller: otpController,
                        onChanged: (value){
                          code=value;
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Enter OTP',
                          prefixIcon: Icon(Icons.message),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: ()  async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (content) => loginScreen(),
                            ),
                          );
                          try{
                            PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: HomePage.verify, smsCode: code);
                            await auth.signInWithCredential(credential);
                            // Implement OTP verification logic here
                            String enteredOTP = otpController.text;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (content) => loginScreen(),
                              ),
                            );
                          }
                          catch(e){
                            print("wrong otp");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.purple, // Text color
                          padding: const EdgeInsets.all(
                              16.0), // Padding
                          textStyle: const TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        child: const Text('Verify OTP'),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}