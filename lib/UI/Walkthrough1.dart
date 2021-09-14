import 'package:flutter/material.dart';
import 'package:to_do_app/Route/route.dart';
class Walkthrough1 extends StatefulWidget{
  Walkthrough1State createState()=> Walkthrough1State();
}
class Walkthrough1State extends State<Walkthrough1> {

  int count=1;

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            Expanded(
              flex: 4,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child:(count==1)? Image.asset('asset/image/walk_through_1_1.png'):(count==2)?Image.asset('asset/image/undraw_superhero_kguv.png'):(count==3)?Image.asset('asset/image/undraw_analysis_4jis.png'):Image.asset('asset/image/walk_through_1_1.png'),
                padding: EdgeInsets.only(top: 60),
              )),
            Expanded(
            flex: 2,
            child:(count==1)? Column(
              children: [
                Image.asset('asset/image/Welcome.png',
                  height: 50,
                ),
                Image.asset('asset/image/Whats_going_to_happe.png',
                  height: 40,
                ),
                Image.asset('asset/image/bacham.png',
                  height: 40,
                ),
              ],
            ):(count==2)?Column(
              children: [
                Image.asset('asset/image/Work_happens.png',
                  height: 50,
                ),
                Image.asset('asset/image/Get_notified_ when_ wo.png',
                  height: 40,
                ),
                Image.asset('asset/image/Pagination.png',
                  height: 40,
                ),
              ],
            ):(count==3)?Column(
              children: [
                Image.asset('asset/image/Tasks and assign.png',
                  height: 50,
                ),
                Image.asset('asset/image/Task and assign them.png',
                  height: 40,
                ),
                Image.asset('asset/image/Pagination (1).png',
                  height: 40,
                ),
              ],
            ):Column(
              children: [
                Image.asset('asset/image/Welcome.png',
                  height: 50,
                ),
                Image.asset('asset/image/Whats_going_to_happe.png',
                  height: 40,
                ),
                Image.asset('asset/image/bacham.png',
                  height: 40,
                ),
              ],
            ),
          ),
            Expanded(
            flex: 4,
            child: Container(
              child: Stack(
                children: [
                  (count==1)?Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('asset/image/Group.png'))),
                  ):(count==2)?Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('asset/image/Group (1).png'))),
                  ):(count==3)?Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('asset/image/Group (2).png'))),
                  ):Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('asset/image/Group.png'))),
                  ),
                  Container(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    (count<3)?count++:Navigator.pushNamed(context, Routes.SignIn);
                                  });
                                  
                                },
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Center(
                                          child: Image.asset('asset/image/Rectangle_2.png')),
                                      Center(
                                          child: Image.asset('asset/image/Get_Started.png'))
                                    ])),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, Routes.SignIn);
                              },
                              child: Center(
                                  child: Image.asset('asset/image/Log In.png')))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}