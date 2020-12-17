import 'package:aplikasipekerti/auth_page/login_page/login_home.dart';
import 'package:aplikasipekerti/dashboard/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthState extends StatefulWidget {
  @override
  _AuthStateState createState() => _AuthStateState();
}

class _AuthStateState extends State<AuthState> {
  @override

//FirebaseUser user = await FirebaseAuth.instance.currentUser();
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    getUser().then((user) {
      if (user != null) {
        print("user was registered");
        // send the user to the home page
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DashboardPage(userId: user.uid)));
      } else {
        print("please register");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPage()));
      }
    });
  }

  Future<FirebaseUser> getUser() async {
    return await FirebaseAuth.instance.currentUser();
  } //  final FirebaseAuth _auth = FirebaseAuth.instance;

  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(child: CircularProgressIndicator(backgroundColor: Colors.white,)),
    );
//     return Container(
// if(user != null){
//   // navigate to home page
// }
// else
// {
// // log in
// }
//     );
  }
}
