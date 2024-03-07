import 'package:firebase/post/post_screen.dart';
import 'package:firebase/ui/auth/login_with_phone.dart';
import 'package:firebase/ui/signup.dart';
import 'package:firebase/utils/utils.dart';
import 'package:firebase/widget/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  bool loading = false;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void loginAuth() {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text.toString())
        .then((value) {
      setState(() {
        loading = false;
      });
      Utils().tostMassage("login sucessfull");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PostScreen()));
    }).onError((error, stackTrace) {
      loading = false;
      Utils().tostMassage(error.toString());
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text('Login screen'),
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
                          prefixIcon: Icon(Icons.email),
                          hintText: 'email',
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
                  widgth: MediaQuery.of(context).size.width * 0.90,
                  loading: loading,
                  title: 'login with email',
                  onPress: () {
                    if (_formKey.currentState!.validate()) {
                      loginAuth();
                    }
                  }),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.05, // 10% of the screen width
                  ),
                  Text("don't have account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Signup()));
                      },
                      child: Text('Signup')),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginWithPhoneNumber()));
                  },
                  child: Container(
                    height: 50,
                    child: Center(child: Text('login with phone')),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.black,
                        )),
                  ),
                ),
              )
            ]),
      ),
    );
  }
}
