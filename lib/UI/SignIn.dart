import 'package:flutter/material.dart';
import 'package:to_do_app/Route/route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_app/UI/WorkList.dart';

class SignIn extends StatelessWidget {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 45),
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 35,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.Walkthrough1);
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 30, right: 30),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Image.asset('asset/image/Welcome back.png'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 10, right: 30),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Image.asset('asset/image/Sign in to continue.png'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 30, left: 30, bottom: 10, right: 30),
                child: Container(
                  alignment: Alignment.centerLeft,
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
                      labelStyle:
                          TextStyle(color: Color(0xff313131), fontSize: 25)),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 40, left: 30, bottom: 10, right: 30),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Image.asset('asset/image/Password.png'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Container(
                    child: TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    contentPadding: EdgeInsets.only(bottom: 3),
                    labelStyle:
                        TextStyle(color: Color(0xff313131), fontSize: 25),
                  ),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30, top: 2),
                child: Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.ForgotPassword);
                      },
                      child:
                          Image.asset('asset/image/Forgot password nho.png')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: TextButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                      .collection('users')
                          .where("subname",isEqualTo:_username.text.trim().toString())
                      .where("password",isEqualTo:_password.text.trim().toString())
                      .snapshots().listen((data) {
                        if (data.docs.isEmpty) {
                          AlertDialog(
                            title: Text("Username/password is not exist"),
                            actions: [
                              TextButton(onPressed: (){
                                Navigator.pop(context);
                              }, child: Text("OK"))
                            ],
                          );
                        }
                        else
                          {
                            Navigator.pushAndRemoveUntil(
                                context,MaterialPageRoute(builder: (_)=>WorkList(userID: data.docs[0]["index"].toString())), (route) => false);
                          }
                      });

                    },
                    child: Stack(alignment: Alignment.center, children: [
                      Center(child: Image.asset('asset/image/Rectangle 2.png')),
                      Center(child: Image.asset('asset/image/Log In (1).png'))
                    ])),
              ),
            ],
          ),
        ));
  }
}
