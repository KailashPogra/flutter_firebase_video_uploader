import 'package:firebase/post/post_screen.dart';
import 'package:firebase/utils/utils.dart';
import 'package:firebase/widget/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading = false;
  bool loading2 = false;
  final auth = FirebaseAuth.instance;

  final phoneNumberController = TextEditingController();
  final verificationController = TextEditingController();
  String? verificationId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('verify'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              // keyboardType: TextInputType.phone,
              controller: phoneNumberController,
              decoration: const InputDecoration(
                hintText: '+91 123 4032 432',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: RoundButton(
                buttonColor: Colors.transparent,
                title: 'send otp',
                loading: loading,
                onPress: () {
                  setState(() {
                    loading = true;
                  });
                  auth.verifyPhoneNumber(
                    phoneNumber: phoneNumberController.text,
                    verificationCompleted: (_) {
                      setState(() {
                        loading = false;
                      });
                    },
                    verificationFailed: (e) {
                      setState(() {
                        loading = false;
                      });
                      debugPrint(e.toString());
                      Utils().tostMassage(e.toString());
                    },
                    codeSent: (String verId, int? token) {
                      setState(() {
                        loading = false;
                        verificationId = verId;
                      });
                    },
                    codeAutoRetrievalTimeout: (e) {
                      debugPrint(e);
                      setState(() {
                        loading = false;
                      });
                      Utils().tostMassage(e.toString());
                    },
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: verificationController,
              decoration: const InputDecoration(hintText: '6 digits code'),
            ),
          ),
          RoundButton(
              title: 'verify code',
              loading: loading2,
              onPress: () async {
                setState(() {
                  loading2 = true;
                });
                final crendital = PhoneAuthProvider.credential(
                    verificationId: verificationId!,
                    smsCode: verificationController.text.toString());

                try {
                  await auth.signInWithCredential(crendital);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PostScreen()));
                } catch (e) {
                  setState(() {
                    loading2 = false;
                  });
                  Utils().tostMassage(e.toString());
                }
              })
        ],
      ),
    );
  }
}
