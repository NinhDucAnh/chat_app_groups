import 'package:chat_app_firebase/screens/login_screen.dart';
import 'package:chat_app_firebase/screens/profile_screen.dart';
import 'package:chat_app_firebase/screens/search_screen.dart';
import 'package:chat_app_firebase/services/auth_service.dart';
import 'package:chat_app_firebase/services/database_service.dart';
import 'package:chat_app_firebase/utils/helper_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String email = "";
  String userName = "";
  AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                HelperFunction.nextScreenReplace(context, const SearchScreen());
              },
              icon: const Icon(Icons.search)),
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        title: const Text(
          'Groups',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 27),
        ),
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
              userName,
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
              onTap: () {},
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
                HelperFunction.nextScreenReplace(
                    context, ProfileScreen(email: email, fullName: userName,));
              },
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
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  gettingUserData() async {
    await HelperFunction.getUserEmailLoggedIn().then((value) {
      setState(() {
        email = value!;
      });
    });

    await HelperFunction.getUserNameLoggedIn().then((value) {
      setState(() {
        userName = value!;
      });
    });

    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroup()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        // make some checks
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index) {
                  int reverseIndex = snapshot.data['groups'].length - index - 1;
                  return GroupTile(
                      groupId: getId(snapshot.data['groups'][reverseIndex]),
                      groupName: getName(snapshot.data['groups'][reverseIndex]),
                      userName: snapshot.data['fullName']);
                },
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
                color: Theme
                    .of(context)
                    .primaryColor),
          );
        }
      },
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Create a group',
              textAlign: TextAlign.left,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isLoading == true ?
                Center(child: CircularProgressIndicator(color: Theme
                    .of(context)
                    .primaryColor,))
                    : TextFormField(
                  onChanged: (value) {
                    setState(() {
                      groupName = value
                    });
                  },
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme
                            .of(context)
                            .primaryColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme
                            .of(context)
                            .primaryColor),
                        borderRadius: BorderRadius.circular(20),
                      )
                  ),
                )
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor
                  ),
                  child: const Text('Cancel')),
              ElevatedButton(
                  onPressed: () async {
                    if(groupName !=""){
                      setState(() {
                        _isLoading = true;
                      });
                      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).createGroup(userName, FirebaseAuth.instance.currentUser!.uid, groupName).whenComplete(() {
                        _isLoading = false;
                      });
                      Navigator.of(context).pop();
                      HelperFunction.showSnackBar(context, Theme.of(context).primaryColor, "Group created successfully");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor
                  ),
                  child: const Text('Create'))
            ],
          );
        }
    )
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[700],
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You've not joined any groups, tap on the add icon to create a group or also search from top search button.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

}




