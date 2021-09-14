import 'package:flutter/material.dart';
import 'dart:async';

import 'package:to_do_app/Route/route.dart';
class Successfull extends StatefulWidget {
  @override
  SuccessfullState createState() => SuccessfullState();
}

class SuccessfullState extends State<Successfull> {


  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 3), (_timer) {
      Navigator.pushNamed(context, Routes.SignIn);
      _timer.cancel();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Image.asset('asset/image/Group 2.png'),
        ),
      ),
    );
  }
}