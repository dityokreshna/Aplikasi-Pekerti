import 'package:aplikasipekerti/auth_page/signup_page/signup_home.dart';
import 'package:aplikasipekerti/dashboard/dashboard.dart';
import 'package:aplikasipekerti/firebase_service/database_service.dart';
import 'package:aplikasipekerti/firebase_service/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _signinformKey = GlobalKey<FormState>();
//  String email;
//  String pass;
  final _email = TextEditingController();
  final _pass = TextEditingController();
  String _error;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _signinformKey,
        child: Column(children: <Widget>[
          _textForm("Email", Icons.email, _email),
          _textForm("Password", Icons.vpn_key, _pass),
          _error == null
              ? SizedBox()
              : Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    _error,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: InkWell(
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  //border: Border.all(),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent,
                      blurRadius: 5,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    "Sign In",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              onTap: () async {
                // print(_email.text);
                dynamic _signinResult =
                    await AuthServices.signIn(_email.text, _pass.text);
                // print("SIGN IN RESULT : " + _signinResult.toString());
                if (_signinResult != null) {
                  FirebaseUser user = await FirebaseAuth.instance.currentUser();   
                  String mainan = await DatabaseService.instance.getuserProfile(user.uid);               
                  // print(user);
                  if (user.uid != null && mainan == null) {
                    setState(
                      () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DashboardPage(userId: user.uid)));
//                      Navigator.of(context).push(
                        //                        MaterialPageRoute(builder: (context) => HomePage()));
                      },
                    );
                  }
                } else {
                  setState(() {
                    _error = "Email atau Password salah";
                  });
                }
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Belum Punya Akun? ",
                  textAlign: TextAlign.center,
                ),
                /*Text(
                                  "Daftar", style: TextStyle(color: Colors.blue),
                                  ),*/
                new GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignupPage()));
                  },
                  child: Text(
                    "Daftar",
                    style: TextStyle(color: Colors.blue),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _textForm(String formText, IconData formIcon, dynamic formState) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.85,
      padding: EdgeInsets.fromLTRB(0, 7, 0, 5),
      child: Center(
        child: TextFormField(
          onTap: (){
            setState(() {
              _error = "";
            });
          },
          cursorRadius: Radius.circular(10),
          controller: formState,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              prefixIcon: Icon(formIcon),
              //prefixText: "Email:",
              prefixStyle:
                  TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
              hintText: formText,
              hintStyle: TextStyle(
                  color: Colors.black12,
                  fontWeight: FontWeight.w400,
                  height: 0.5),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.blue))),
          //validator: (val) => val.isEmpty ? 'Isi Email Yang bener Woy' : null,
          /* onChanged: (val) {
              setState(() {
                formState = val;
                print(formState);
              });
            }*/
        ),
      ),
    );
  }
}
