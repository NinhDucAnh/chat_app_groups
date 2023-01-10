import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("user");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("group");

  Future savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName" :fullName,
      "email" : email,
      "groups" : [],
      "profilePic" : "",
      "uid" : uid,
    });
  }

  Future getttingUserData (String email) async{
    QuerySnapshot snapshot = await userCollection.where("email",isEqualTo: email).get();
    return snapshot;
  }

  getUserGroup() async {
    return userCollection.doc(uid).snapshots();
  }

  Future createGroup(String userName, String id, String groupName) async{
    DocumentReference dr = await groupCollection.add({
    "groupName": groupName,
    "groupIcon": "",
    "admin": "${id}_$userName",
    "members":[],
    "groupId":"",
    "recentMessage": "",
    "recentMessageSender":""
    });

    await dr.update(
      {
        "member" : FieldValue.arrayUnion(["${uid}_$userName"]),
        "groupId" : dr.id,
      }
    );

    DocumentReference udr =  userCollection.doc(uid);
    return await udr.update(
      {
        "groups" : FieldValue.arrayUnion(["${dr.id}_$groupName"])
      }
    );
  }
}
