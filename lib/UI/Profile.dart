import 'package:flutter/material.dart';
import 'package:to_do_app/Route/route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_app/UI/Project.dart';
import 'package:to_do_app/UI/Quick.dart';
import 'package:to_do_app/UI/WorkList.dart';
import 'package:to_do_app/UI/CreateTask.dart';
import 'package:to_do_app/UI/CreateNode.dart';
import 'package:to_do_app/UI/CreateCheckList.dart';
class Profile extends StatefulWidget {
  final String userID;
  const Profile({Key? key,required this.userID}):super(key:key);
  ProfileState createState() => ProfileState();
}
enum menu { AddTask, AddQuickNote, AddCheckList }
class ProfileState extends State<Profile> {
  Future<void> _askedToLead() async {
    switch (await showDialog<menu>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, menu.AddTask);
                },
                child: Center(
                    child:
                    const Text('Add Task', style: TextStyle(fontSize: 20))),
              ),
              Divider(),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, menu.AddQuickNote);
                },
                child: Center(
                    child: const Text('Add Quick Note',
                        style: TextStyle(fontSize: 20))),
              ),
              Divider(),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, menu.AddCheckList);
                },
                child: Center(
                    child: const Text('Add Check List',
                        style: TextStyle(fontSize: 20))),
              ),
            ],
          );
        })) {
      case menu.AddTask:
      // Let's go.
      // ...
        Navigator.push(context, MaterialPageRoute(builder: (_)=>CreateTask(userID: widget.userID)));
        break;
      case menu.AddQuickNote:
        Navigator.push(context, MaterialPageRoute(builder: (_)=>CreateNode(userID: widget.userID)));
      // ...
        break;
      case menu.AddCheckList:
        Navigator.push(context, MaterialPageRoute(builder: (_)=>CreateCheckList(userID: widget.userID)));
      // ...
        break;
      case null:
      // dialog dismissed
        break;
    }
  }

  Container _cardContainer(String a, String b, int _color) {
    return Container(
        decoration: BoxDecoration(
          color: Color(_color),
          borderRadius: BorderRadius.circular(10),
        ),
        width: 160,
        height: 100,
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(a,
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'AvenirNextRoundedPro',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFFFFFF))),
                SizedBox(height: 6),
                Text(b,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Avenir Next Rounded Pro',
                        color: Color(0xFFFFFFFF)))
              ]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference user= FirebaseFirestore.instance.collection("users");
    // TODO: implement build
    return FutureBuilder<DocumentSnapshot>(
        future:user.doc(widget.userID).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              backgroundColor: Color(0xFFFDFDFD),
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(50.0), // here the desired height
                child: AppBar(
                  leading: null,
                  centerTitle: true,
                  backgroundColor: Color(0xFFFFFFFF),
                  bottomOpacity: 10.0,
                  title: Text('Profiles',
                      style: TextStyle(
                          fontSize: 22,
                          color: Color(0xFF313131),
                          fontWeight: FontWeight.w500)),
                ),
              ),
              body: Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 16, right: 16),
                  child: ListView(children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 190,
                      decoration: BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 0.5,
                            blurRadius: 3,
                            offset: Offset(3.0, 3.0)),
                      ]),
                      child: Stack(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0, left: 23),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 64,
                                    width: 64,
                                    child: CircleAvatar(
                                      child: Image.asset(data["link"]),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data['name'],
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'AvenirNextRoundedPro',
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(data['subname'],
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Avenir Next Rounded Pro'))
                                      ])
                                ],
                              ),
                              SizedBox(height: 30),
                              StreamBuilder<QuerySnapshot>(
                                  stream:FirebaseFirestore.instance.collection('users').doc(widget.userID).collection('task').snapshots(),
                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                    if(snapshot.hasData){
                                      List<QueryDocumentSnapshot<Object?>> data = snapshot.data!.docs;
                                      List<QueryDocumentSnapshot<Object?>> completeData = [];
                                      for (int i = 0; i < data.length; i++) {
                                        if (data[i]['state']==1) {
                                          completeData.add(data[i]);
                                        }
                                      }
                                      return Row(
                                        children: [
                                          Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data.length.toString(),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: 'AvenirNextRoundedPro',
                                                      fontWeight: FontWeight.w500,
                                                      color: Color(0xFF313131)),
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Text(
                                                  'Create Tasks',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'Avenir Next Rounded Pro',
                                                      fontWeight: FontWeight.w500,
                                                      color: Color(0xFF9A9A9A)),
                                                ),
                                              ]),
                                          SizedBox(width: 53),
                                          Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  completeData.length.toString(),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: 'AvenirNextRoundedPro',
                                                      fontWeight: FontWeight.w500,
                                                      color: Color(0xFF313131)),
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Text(
                                                  'Completed Tasks',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'Avenir Next Rounded Pro',
                                                      fontWeight: FontWeight.w500,
                                                      color: Color(0xFF9A9A9A)),
                                                ),
                                              ])
                                        ],
                                      );
                                    }
                                    return Container();
                                  })
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10, right: 10),
                          child: Image.asset('asset/image/Fill 1 (2).png'),
                          alignment: Alignment.topRight,
                        )
                      ]),
                    ),
                    SizedBox(height: 5),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      height: 100.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          _cardContainer('Events', '12 Tasks', 0xFFF96060),
                          SizedBox(height: 100, width: 10),
                          _cardContainer('To do Task', '12 Tasks', 0xFF6074F9),
                          SizedBox(height: 100, width: 10),
                          _cardContainer('Quick Notes', '12 Tasks', 0xFF8560F9)
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: 205,
                      width: 343,
                      color: Color(0xFFFFFFFF),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0, left: 24),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Statistic',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'AvenirNextRoundedPro',
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF313131))),
                              SizedBox(
                                height: 21,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                        height: 114,
                                        width: 80,
                                        child: Image.asset('asset/image/Group 11.png')),
                                    SizedBox(
                                        child:
                                        Image.asset('asset/image/Group 11 Copy 2.png')),
                                    SizedBox(
                                        child: Image.asset('asset/image/Group 11 Copy.png')),
                                  ])
                            ]),
                      ),
                    )
                  ])),
              bottomNavigationBar: SizedBox(
                height: 70.0,
                child: BottomAppBar(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: IconButton(
                              icon: Image.asset('asset/image/Page 1 (5).png'),
                              iconSize: 30,
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_)=>WorkList(userID:widget.userID)));
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Text('My Task',
                                style: TextStyle(color: Color(0xff8E8E93))),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: IconButton(
                                icon: Image.asset('asset/image/Page 1 (2).png'),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_)=>Projects(userID:widget.userID)));
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Text('Menu',
                                style: TextStyle(color: Color(0xff8E8E93))),
                          )
                        ],
                      ),
                      Divider(
                        color: Color(0xff292E4E),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: IconButton(
                                icon: Image.asset('asset/image/Page 1 (3).png'),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_)=>Quick(userID:widget.userID)));
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Text('Quick',
                                style: TextStyle(color: Color(0xff8E8E93))),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: IconButton(
                                icon: Image.asset('asset/image/Page 1(3).png'),
                                onPressed: () {}),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child:
                            Text('Profile', style: TextStyle(color: Colors.white)),
                          )
                        ],
                      ),
                    ],
                  ),
                  color: Color(0xff292E4E),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  backgroundColor: Color(0xffF96060),
                  onPressed: () {
                    _askedToLead();
                  }),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            );
          }

          return Text("loading");
        }
    );
  }
}