import 'package:aplikasipekerti/firebase_service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<FirebaseUser> signUp(String email, String password, String username,String noktp, String alamat, String status) async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      String userId = await DatabaseService.instance.inputData();
//      await DatabaseService.instance.userlistData(status, userId,username,noktp,alamat);
      await DatabaseService.instance.userregisterData(status, userId,username,noktp,alamat);
      return firebaseUser;      
    }catch(e){
      print(e.toString());
      return null;
    }
  }
    static Future<FirebaseUser> signIn(String email, String password) async{

      String errorData;
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return firebaseUser;      
    }catch(error){
      print(error.toString());
      return null;
    }
  }

  static Future<void> signOut() async{
    await _auth.signOut();
  }


  Future <void> userregisterData()async{
    
  }

}