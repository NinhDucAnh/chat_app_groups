import 'package:chat_app_firebase/screens/home_screen.dart';
import 'package:chat_app_firebase/services/auth_service.dart';
import 'package:chat_app_firebase/utils/helper_function.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  String fullName;
  String email;
  ProfileScreen({Key? key, required this.email , required this.fullName}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            Icon(
              Icons.account_circle,
              size: 159,
              color: Colors.grey[700],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              widget.fullName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: () {
                HelperFunction.nextScreenReplace(context, const HomeScreen());
              },
              selectedColor: Theme
                  .of(context)
                  .primaryColor,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: const Icon(Icons.group),
              title: const Text(
                'Groups',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
              },
              selected: true,
              selectedColor: Theme
                  .of(context)
                  .primaryColor,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: const Icon(Icons.person),
              title: const Text(
                'Profile',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout'),
                        actions: [
                          IconButton(onPressed: () {
                            Navigator.pop(context);
                          },
                              icon: const Icon(
                                Icons.cancel, color: Colors.red,)),
                          IconButton(onPressed: () async {
                            await authService
                                .signOut()
                                .whenComplete(() =>
                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(builder: (
                                        context) => const LoginScreen(),), (
                                        route) => false));
                          },
                              icon: const Icon(
                                Icons.done, color: Colors.green,))
                        ],
                      ),
                );
              },
              selectedColor: Theme
                  .of(context)
                  .primaryColor,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: const Icon(Icons.logout),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 170),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.account_circle,
              size: 200,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment:  MainAxisAlignment.spaceBetween,
              children: [
                const Text('Full Name:', style: TextStyle(fontSize: 17),),
                Text(widget.fullName,style: const TextStyle(fontSize: 17),),
              ],
            ),
            const Divider(height: 20,),
            Row(
              mainAxisAlignment:  MainAxisAlignment.spaceBetween,
              children: [
                const Text('Email:', style: TextStyle(fontSize: 17),),
                Text(widget.email,style: const TextStyle(fontSize: 17),),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
