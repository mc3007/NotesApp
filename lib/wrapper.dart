import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pages/Authentication/logiIn.dart';
import 'package:pages/home.dart';

class CurrentState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var _state=FirebaseAuth.instance.currentUser;
    return _state!=null ? HomePage() : LogIn();
  }
}
