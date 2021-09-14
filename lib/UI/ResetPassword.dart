import 'package:flutter/material.dart';
import 'package:to_do_app/Route/route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ResetPassword extends StatefulWidget {
  final String userID;
  const ResetPassword({Key? key,required this.userID}):super(key:key);
  ResetPasswordState createState()=> ResetPasswordState();
}
class ResetPasswordState extends State<ResetPassword>{
  TextEditingController _newPassword=TextEditingController();
  TextEditingController _confirmPassword=TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(),
          ),
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              )),
          Expanded(
              flex: 8,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30, top: 0, right: 30),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Reset Password",
                        style: TextStyle(
                            fontSize: 36,
                            fontFamily: "AvenirNextRoundedPro",
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, top: 10, right: 20),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Reset code was sent to your phone. Please enter the code and create new password",
                        style: TextStyle(fontSize: 16,fontFamily: "Avenir Next Rounded Pro",color:Color(0xFF9B9B9B)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 30, bottom: 0, right: 30),
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child:Text("Reset code",style: TextStyle(fontSize: 20,fontFamily: "Avenir Next Rounded Pro",fontWeight: FontWeight.w500),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Container(
                        child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Enter your number',
                          contentPadding: EdgeInsets.only(bottom: 3),
                          labelStyle: TextStyle(
                              color: Color(0xff313131), fontSize: 25)),
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 40, left: 30, bottom: 0, right: 30),
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Text("New password",style: TextStyle(fontSize: 20,fontFamily: "Avenir Next Rounded Pro",fontWeight: FontWeight.w500)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Container(
                        child: TextField(
                          controller: _newPassword,
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
                    padding: const EdgeInsets.only(
                        top: 40, left: 30, bottom: 0, right: 30),
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Text("Confirm password",style: TextStyle(fontSize: 20,fontFamily: "Avenir Next Rounded Pro",fontWeight: FontWeight.w500)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Container(
                        child: TextField(
                          controller: _confirmPassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter your confirm password',
                        contentPadding: EdgeInsets.only(bottom: 3),
                        labelStyle:
                            TextStyle(color: Color(0xff313131), fontSize: 25),
                      ),
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Container(
                      child: TextButton(
                          onPressed: () async {
                            if (_newPassword.text==_confirmPassword.text)
                            {
                              await FirebaseFirestore.instance
                                  .collection("users").doc(widget.userID).update(
                                  {
                                    "password":_newPassword.text,
                                  });
                              Navigator.pushNamed(context, Routes.Successfull);
                            }
                            else
                              {
                                AlertDialog(
                                  title: Text("Confirm password is not the same new password"),
                                  actions: [
                                    TextButton(onPressed: (){
                                      Navigator.pop(context);
                                    }, child: Text("OK"))
                                  ],
                                );
                              }
                          },
                          child: Stack(alignment: Alignment.center, children: [
                            Center(
                                child:
                                    Image.asset('asset/image/Rectangle 2.png')),
                            Center(
                                child: Image.asset(
                                    'asset/image/Change password.png'))
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
