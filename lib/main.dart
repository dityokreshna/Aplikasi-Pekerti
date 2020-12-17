import 'package:aplikasipekerti/auth_page/auth_state.dart';
import 'package:flutter/material.dart';

import 'auth_page/login_page/login_home.dart';


void main() => runApp(PekertiApps());

class PekertiApps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthState(),
    );
  }
}
