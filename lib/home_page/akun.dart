import 'package:aplikasipekerti/auth_page/login_page/login_home.dart';
import 'package:aplikasipekerti/firebase_service/firebase_auth_service.dart';
import 'package:flutter/material.dart';

class AkunPage extends StatefulWidget {
  @override
  _AkunPageState createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: InkWell(
                    child: Container(
                      height: 40,
                      width: 100,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.red,
                        elevation: 10,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.exit_to_app, color: Colors.white),
                              Text(
                                "Keluar",
                                style: TextStyle(color: Colors.white),
                              )
                            ]),
                      ),
                    ),
                    onTap: () async {
                      await AuthServices.signOut();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _listmenuAkun(String daftarmenuAkun, apaList) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Center(
        child: ListTile(
          title: Text(daftarmenuAkun),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => apaList));
          },
        ),
      ),
    );
  }
}
