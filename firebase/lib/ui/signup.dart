import 'package:firebase/post/post_screen.dart';
import 'package:firebase/ui/login.dart';
import 'package:firebase/utils/utils.dart';
import 'package:firebase/widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _loginState();
}

class _loginState extends State<Signup> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signupAuth() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      _auth
          .createUserWithEmailAndPassword(
              email: emailController.text.toString(),
              password: passwordController.text.toString())
          .then((value) {
        Utils().tostMassage('signup succesfully');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PostScreen()));
        setState(() {
          loading = false;
        });
      }).onError((error, stackTrace) {
        Utils().tostMassage(error.toString());
        setState(() {
          loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amberAccent,
          title: Text('signUp screen'),
          centerTitle: true,
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Adjust the border radius as needed
                            borderSide: BorderSide(
                                color: Colors
                                    .blue), // Adjust the border color as needed
                          ),
                          // You can also customize the focused border
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: Colors
                                    .green), // Change the color for focused state
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'enter email';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: 'password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Adjust the border radius as needed
                            borderSide: BorderSide(
                                color: Colors
                                    .blue), // Adjust the border color as needed
                          ),
                          // You can also customize the focused border
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: Colors
                                    .green), // Change the color for focused state
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'enter password';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RoundButton(
                  buttonColor: Colors.amberAccent,
                  title: 'Signup',
                  loading: loading,
                  onPress: () {
                    signupAuth();
                  }),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.05, // 10% of the screen width
                  ),
                  Text("have account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => login()));
                      },
                      child: Text('login')),
                ],
              )
            ]),
      ),
    );
  }
}
