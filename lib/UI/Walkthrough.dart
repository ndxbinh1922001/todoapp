import 'package:flutter/material.dart';
import 'dart:async';
class Walkthrough extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WalkthroughPage();
}

class WalkthroughPage extends State<Walkthrough> {
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (_timer) {
      Navigator.popAndPushNamed(context, '/Walkthrough1');
      _timer.cancel();
    });
  }

  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Image.asset('asset/image/fill1.png'),
                      padding: EdgeInsets.only(bottom: 12),
                    ),
                    Image.asset('asset/image/aking.png')
                  ],
                ),
              )),
        ],
      ),
    );
  }
}