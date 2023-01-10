import 'package:chat_app_firebase/screens/home_screen.dart';
import 'package:chat_app_firebase/screens/login_screen.dart';
import 'package:chat_app_firebase/services/auth_service.dart';
import 'package:chat_app_firebase/utils/helper_function.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../utils/widgets_decoration.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isLoading = false;
  String email = "";
  String password = "";
  String fullName = "";
  final formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: _isLoading ? Center(
              child: CircularProgressIndicator(color: Theme
                  .of(context)
                  .primaryColor,)) : SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
                      'Create your account now to chat and explore',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Image.asset('assets/register.png'),
                    TextFormField(
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Full name',
                            prefixIcon: Icon(
                              Icons.person,
                              color: Theme
                                  .of(context)
                                  .primaryColor,
                            )),
                        onChanged: (value) =>
                            setState(() {
                              fullName = value;
                            }),
                        validator: (value) =>
                        value!.isEmpty
                            ? "Enter your full name"
                            : null
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          labelText: 'Email',
                          prefixIcon: Icon(
                            Icons.email,
                            color: Theme
                                .of(context)
                                .primaryColor,
                          )),
                      onChanged: (value) =>
                          setState(() {
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
                            color: Theme
                                .of(context)
                                .primaryColor,
                          )),
                      validator: (value) {
                        if (value!.length < 6) {
                          return "Password must be at least 6 characters";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) =>
                          setState(() {
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
                          register();
                        },
                        child: const Text(
                          'Register',
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
                        text: "Already have an account?",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                              text: ' Login here',
                              style: const TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  HelperFunction.nextScreenReplace(
                                      context, const LoginScreen());
                                })
                        ])),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  register() async {
    if (formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      await authService.registerUserWithEmailAndPassword(fullName, email, password).then((value) async {
          if(value == true){
              await HelperFunction.saveUserLoggedInStatus(true);
              await HelperFunction.saveUserEmail(email);
              await HelperFunction.saveUserName(fullName);
              HelperFunction.nextScreenReplace(context, const HomeScreen());
          }else{
            HelperFunction.showSnackBar(context, Theme.of(context).primaryColor, value );
            setState(() {
              _isLoading  = false;
            });
          }
      });
    }
  }
}
