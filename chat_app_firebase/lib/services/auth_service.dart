import 'package:chat_app_firebase/services/database_service.dart';
import 'package:chat_app_firebase/utils/helper_function.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future loginUserNameAndPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth
          .signInWithEmailAndPassword( email: email, password: password))
          .user!;

      if(user != null){
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }



  Future registerUserWithEmailAndPassword(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth
          .createUserWithEmailAndPassword( email: email, password: password))
          .user!;

      if(user != null){
         await DatabaseService(uid : user.uid).savingUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signOut () async {
    try{
      // print(await HelperFunction.saveUserLoggedInStatus(false));
      // print(await HelperFunction.saveUserName(""));
      // print(await HelperFunction.saveUserEmail(""));
      print(await HelperFunction.clearSF());
      await firebaseAuth.signOut();
    } catch(e){
      return null;
    }
  }

}
