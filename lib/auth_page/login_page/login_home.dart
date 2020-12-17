import 'package:flutter/material.dart';
import 'login_form.dart';

class LoginPage extends StatelessWidget {
//  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            //Background(),
            SingleChildScrollView(
                child: Column(
              children: <Widget>[
 Container(
                    width: 200,
                    height: 200,
                    child: Image.asset('images/logo_pekerti.png')),
                LoginForm(),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
