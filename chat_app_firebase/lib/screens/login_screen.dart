import 'package:chat_app_firebase/screens/home_screen.dart';
import 'package:chat_app_firebase/screens/register_screen.dart';
import 'package:chat_app_firebase/services/auth_service.dart';
import 'package:chat_app_firebase/services/database_service.dart';
import 'package:chat_app_firebase/utils/constants.dart';
import 'package:chat_app_firebase/utils/helper_function.dart';
import 'package:chat_app_firebase/utils/widgets_decoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Groupie',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Login now to see what they are talking!',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Image.asset('assets/login.png'),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Email',
                            prefixIcon: Icon(
                              Icons.email,
                              color: Theme.of(context).primaryColor,
                            )),
                        onChanged: (value) => setState(() {
                          email = value;
                        }),
                        validator: (value) =>
                            RegExp(Constants.regexEmailValid).hasMatch(value!)
                                ? null
                                : "Please enter a valid email",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Password',
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Theme.of(context).primaryColor,
                            )),
                        validator: (value) {
                          if (value!.length < 6) {
                            return "Password must be at least 6 characters";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) => setState(() {
                          password = value;
                        }),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Constants().primaryColor,
                              foregroundColor: Constants().primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          onPressed: () {
                            login();
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text.rich(TextSpan(
                          text: "Don't have account?",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                                text: ' Register here',
                                style: const TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    HelperFunction.nextScreen(
                                        context, const RegisterScreen());
                                  })
                          ])),
                    ],
                  ),
                ),
              ),
            ),
    ));
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginUserNameAndPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .getttingUserData(email);
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserEmail(email);
          await HelperFunction.saveUserName(snapshot.docs[0]['fullName']);
          HelperFunction.nextScreenReplace(context, const HomeScreen());
        } else {
          HelperFunction.showSnackBar(
              context, Theme.of(context).primaryColor, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
