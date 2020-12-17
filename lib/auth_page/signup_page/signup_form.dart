import 'package:aplikasipekerti/auth_page/login_page/login_home.dart';
import 'package:aplikasipekerti/dashboard/dashboard.dart';
import 'package:aplikasipekerti/firebase_service/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _signupformKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _naktp = TextEditingController();
  final _noktp = TextEditingController();
  final _alamat = TextEditingController();
  final _status = TextEditingController();
  String _errorDetail = "";
  String statusOrang;
  var accessLists = [];

  void dispose() {
    super.dispose();
    _alamat.dispose();
    _email.dispose();
    _naktp.dispose();
    _noktp.dispose();
    _pass.dispose();
    _status.dispose();
  }

  final accessReference =
      FirebaseDatabase.instance.reference().child("levelakses").once();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Form(
          key: _signupformKey,
          child: Column(children: <Widget>[
            _textForm("Email", Icons.email, _email),
            _textForm("Password", Icons.vpn_key, _pass),
            _textForm("Nama KTP", Icons.person, _naktp),
            _textForm("No KTP", Icons.confirmation_number, _noktp),
            _textForm("Alamat Setempat", Icons.home, _alamat),
            _textForm("Kode Daftar", Icons.code, _status),
            Text(
              _errorDetail,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
            FutureBuilder(
                future: accessReference,
                builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    Map<dynamic, dynamic> values = snapshot.data.value;
                    // print(values);
                    values.forEach((key, values) {
                      accessLists.add(values);
                    });
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: InkWell(
                        child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.8,
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
                            child: Center(child: Text("Sign Up"))),
                        onTap: () async {
                          if (_status.text == values["admin"]) {
                            setState(() {
                              statusOrang = "admin";
                            });
                          } else if (_status.text == values["anakkos"]) {
                            setState(() {
                              statusOrang = "anakkos";
                            });
                          } else if (_status.text == values["warga"]) {
                            setState(() {
                              statusOrang = "warga";
                            });
                          } else {
                            setState(() {
                              statusOrang = null;
                              _errorDetail = "Kode Akses Salah";
                            });
                          }
                          // print(_email.text + _pass.text);
                          // print("admin : " + accessLists[0]);
                          // print("anakkos : " + accessLists[1]);
                          // print("warga : " + accessLists[2]);
                          // switch (_status.text) {
                          //   case "001":
                          //     {
                          //       statusOrang = "admin";
                          //     }
                          //     break;
                          //   case "002":
                          //     {
                          //       statusOrang = "warga";
                          //     }
                          //     break;
                          //   case "003":
                          //     {
                          //       statusOrang = "anakkos";
                          //     }
                          //     break;
                          // }
                          if (_email.text.isNotEmpty &&
                              _pass.text.isNotEmpty &&
                              _naktp.text.isNotEmpty &&
                              _noktp.text.isNotEmpty &&
                              statusOrang != null) {
                            await AuthServices.signUp(
                                _email.text,
                                _pass.text,
                                _naktp.text,
                                _noktp.text,
                                _alamat.text,
                                statusOrang);
                            dynamic _signinResult = await AuthServices.signIn(
                                _email.text, _pass.text);
                            if (_signinResult != null) {
                              FirebaseUser user =
                                  await FirebaseAuth.instance.currentUser();
                              if (user.uid != null) {
                                setState(
                                  () {
                                    Navigator.push(
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
                              setState(
                                () {
                                  _errorDetail = "Isi dengan tepat";
                                },
                              );
                            }
                            setState(
                              () {
                                //                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                                //                        builder: (context) => HomePage()));
                              },
                            );
                          } else {
                            setState(
                              () {
                                _errorDetail = "Isi dengan tepat";
                              },
                            );
                          }
                        },
                      ),
                    );
                  }
                  return Center(child: Text("Sambungkan Koneksi"));
                }),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Sudah Punya Akun? ",
                    textAlign: TextAlign.center,
                  ),
                  /*Text(
                                  "Daftar", style: TextStyle(color: Colors.blue),
                                  ),*/
                  new GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text(
                      "Masuk",
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _textForm(String formText, IconData formIcon, formState) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.85,
      padding: EdgeInsets.fromLTRB(0, 7, 0, 5),
      child: Center(
        child: TextFormField(
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
