import 'package:expenseaccount/views/sign_up_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widget/custom_text.dart';
import '../widget/round_button.dart';
import 'home_view.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  void login() {
    _auth
        .signInWithEmailAndPassword(
      email: emailTextController.text.trim(),
      password: passwordTextController.text.trim(),
    )
        .then((value) {
      User? user = value.user;

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeView(
              name: user.displayName,
              email: user.email, // Pass the email here
            ),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeView(
              name: "User",
              email: "No email provided",
            ),
          ),
        );
      }
    }).catchError((error) {
      print('Login failed: $error');
      // Show an error message or a snackbar to the user
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F4F9),
      appBar: AppBar(
        backgroundColor: Color(0xFFF3F4F9),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            CustomText(
              text: 'Log in',
              fontWeight: FontWeight.w800,
              fontsize: 20,
              itemcolor: Colors.black,
            ),
            SizedBox(height: 10),
            CustomText(
              text: 'Welcome back!Please enter your details.',
              fontWeight: FontWeight.w700,
              fontsize: 15,
              itemcolor: Color(0XFFC9C9CA),
            ),
            SizedBox(height: 15),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                      text: "Email",
                      fontWeight: FontWeight.bold,
                      fontsize: 18,
                      itemcolor: Colors.black87),
                  TextFormField(
                    controller: emailTextController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        size: 24, // Adjust icon size if needed
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15), // Circular border with radius 15
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15), // Circular border when focused
                        borderSide: BorderSide(
                          color: Colors.blue, // Border color when focused
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),

                  CustomText(
                      text: "Password",
                      fontWeight: FontWeight.bold,
                      fontsize: 18,
                      itemcolor: Colors.black87),
                  TextFormField(
                    controller: passwordTextController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        size: 24, // Adjust icon size if needed
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15), // Circular border with radius 15
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15), // Circular border when focused
                        borderSide: BorderSide(
                          color: Colors.blue, // Border color when focused
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),

                ],
              ),
            ),
            SizedBox(height: 10),
            RoundButton(
              title: "Login",
              ontab: login,
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: 'Dont have an account?',
                  fontWeight: FontWeight.w700,
                  fontsize: 15,
                  itemcolor: Color(0XFFC9C9CA),
                ),
                TextButton(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpView()),
                  );
                },child: Text('Sign up,',style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.w700
                ),))
              ],
            ),

          ],
        ),
      ),
    );
  }
}
