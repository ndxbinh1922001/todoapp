import 'package:flutter/material.dart';
import 'package:to_do_app/Route/route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_app/UI/ResetPassword.dart';
class ForgotPassword extends StatelessWidget {
  TextEditingController _username=TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset('asset/image/Fill 1.png'),
                  ),
                ),
              )),
          Expanded(
              flex: 8,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, top: 0, right: 30),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(
                            fontSize: 36, fontFamily: "AvenirNextRoundedPro",fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, top: 20, right: 30),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Text("Please enter your email below to receive\nyour password reset instructions",
                      style:TextStyle(fontSize: 16,fontFamily: "Avenir Next Rounded Pro",color: Color(0xFF9B9B9B))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 40, left: 30, bottom: 8, right: 30),
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Image.asset('asset/image/Username.png'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Container(
                        child: TextField(
                          controller: _username,
                      decoration: InputDecoration(
                          hintText: 'Enter your username',
                          contentPadding: EdgeInsets.only(bottom: 3),
                          labelStyle: TextStyle(
                              color: Color(0xff313131), fontSize: 25)),
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Container(
                      child: TextButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .where("subname",isEqualTo:_username.text.trim().toString())
                                .snapshots().listen((data) {
                              if (data.docs.isEmpty) print("empty");
                              else
                              {
                                Navigator.push(
                                    context,MaterialPageRoute(builder: (_)=>ResetPassword(userID: data.docs[0]["index"].toString())));
                              }
                            });
                          },
                          child: Stack(alignment: Alignment.center, children: [
                            Center(
                                child:
                                    Image.asset('asset/image/Rectangle 2.png')),
                            Center(
                                child:
                                    Image.asset('asset/image/Send Request.png'))
                          ])),
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
