import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CreateTask extends StatefulWidget {
  final String userID;
  const CreateTask({Key? key, required this.userID}):super(key:key);
  CreateTaskState createState()=> CreateTaskState();
}
class CreateTaskState extends State<CreateTask>{
  DateTime focusedDay=DateTime.now();
  DateTime selectedDay=DateTime.now();
  bool showAnyTime=true;
  bool showCalendar=false;
  bool showListUser=false;
  bool showListProject=false;
  bool showTextFieldUser=false;
  bool showTextFieldProject=false;
  int indexUser=0;
  int indexProject=0;
  String name="";
  String link="";
  String subname="";
  String nameProject="";
  List<int> memberList=[];
  bool showMember=false;
  TextEditingController? tittle = TextEditingController();
  TextEditingController? description = TextEditingController();
  getUser(){
    FirebaseFirestore.instance
        .collection('users')
        .doc("$indexUser")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          name = documentSnapshot['name'];
          subname = documentSnapshot['subname'];
          link = documentSnapshot['link'];
          indexUser = documentSnapshot['index'];
        });
      } else {
        print('Document does not exist on the database');
      }
    });
  }
  getProject(){
    FirebaseFirestore.instance.collection('users').doc(widget.userID)
        .collection('project')
        .doc("$indexProject")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          nameProject = documentSnapshot['name'];
        });
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  Future<void> addTask () async {
    int length=0;
    int index=0;
    int task=0;
    await FirebaseFirestore.instance
        .collection('users').doc(widget.userID).collection('task')
        .get()
        .then((snap) {
      length = snap
          .docs.length; // will return the collection size
    });
    await FirebaseFirestore.instance.collection('users').doc(widget.userID).collection('task').doc("${length+1}")
        .set({
      'user':name,
      'tittle':tittle!.text,
      'tag':nameProject,
      'member': memberList,
      'due date':focusedDay.toString(),
      'link': link,
      'due time':DateTime.now().hour.toString()+":"+DateTime.now().minute.toString(),
      'description':description!.text,
      'taskID':length+1,
      'state':0
    }).catchError((error) => print("Failed to add user: $error"));
    await FirebaseFirestore.instance
        .collection('users').doc(widget.userID).collection('project')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc['name']==nameProject)
        setState(() {
          index=doc['index'];
          task=doc['task'];
        });
      });
    });

    await FirebaseFirestore.instance
    .collection('users').doc(widget.userID)
        .collection('project')
        .doc(index.toString())
        .update({'task': task+1});
    Navigator.pop(context);
    print(tittle!.text);
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference projects = FirebaseFirestore.instance.collection('users').doc(widget.userID).collection('project');
    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
          DefaultTabController(
              length: 0,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Color(0xFFF96060),
                  leading: IconButton(
                      icon: Image.asset('asset/image/Fill 1(2).png'),
                      onPressed: () {
                        // Do something.
                        Navigator.pop(context);
                      }),
                  bottom: TabBar(
                    tabs: [],
                  ),
                  title: Text(
                    'New Task',
                    style: TextStyle(
                        fontFamily: "AvenirNextRoundedPro", fontSize: 28),
                  ),
                  centerTitle: true,
                ),
                bottomNavigationBar: SizedBox(
                  height: 70.0,
                  child: BottomAppBar(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [],
                    ),
                    color: Color(0xff292E4E),
                  ),
                ),
              )),
          Padding(
              padding: const EdgeInsets.only(
                  top: 120, bottom: 40, left: 20, right: 20),
              child: Stack(children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Column(children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Text('For',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500)),
                              ),
                              Container(child: Stack(children: [
                                SizedBox(
                                    width: 115,
                                    child: TextField(
                                      onTap: (){setState(() {
                                        showListUser=true;
                                      });},
                                      decoration: InputDecoration(
                                        filled: true,
                                        contentPadding: EdgeInsets.only(left: 15,right:15),
                                        fillColor: Color(0xFFF4F4F4),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(30.0),
                                        ),
                                        focusColor: Colors.black,
                                        hintStyle: TextStyle(
                                            color: Colors.grey[800]),
                                        hintText: "  Assignee",
                                      ),
                                      textAlignVertical:
                                      TextAlignVertical.center,
                                    )),
                                if (showTextFieldUser && indexUser!=0)Container(height:50,width: 130,decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    color:Color(0xFFF4F4F4),
                                  borderRadius: BorderRadius.circular(30)
                                ),),
                                if (showTextFieldUser && indexUser!=0)Padding(
                                  padding: const EdgeInsets.only(top:5.0),
                                  child: Row(children: [
                                    SizedBox(width: 10,),
                                    Container(alignment: Alignment.centerLeft,
                                    child:CircleAvatar(child: Image.asset(link))),
                                    SizedBox(width: 10,),
                                    Container(child:Text(name,overflow: TextOverflow.ellipsis,),width: 85,)
                                  ],),
                                )
                              ],),)
                            ],
                          ),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Text('In',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500)),
                                ),
                                Container(child:Stack(alignment:Alignment.center,children:[
                                  SizedBox(
                                      width: 115,
                                      child: TextField(
                                        onTap: (){setState(() {
                                          showListProject=true;
                                        });},
                                        decoration: InputDecoration(
                                          filled: true,
                                          contentPadding: EdgeInsets.only(left:15,right:15),
                                          fillColor: Color(0xFFF4F4F4),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(30.0),
                                          ),
                                          focusColor: Colors.black,
                                          hintStyle:
                                          TextStyle(color: Colors.grey[800]),
                                          hintText: "    Project",
                                        ),
                                        textAlignVertical:
                                        TextAlignVertical.center,
                                      )),
                                  if (showTextFieldProject)Container(height:50,width: 120,decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      color:Color(0xFFF4F4F4),
                                      borderRadius: BorderRadius.circular(30)
                                  ),),
                                  if (showTextFieldProject)Text(nameProject,overflow: TextOverflow.ellipsis,)
                                ]))
                              ],
                            ),


                        ]),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                            color: Color(0xFFF4F4F4),
                            child: Container(
                              padding: EdgeInsets.only(left: 24),
                              child: TextField(
                                controller: tittle,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                  hintText:"Tittle",
                                  hintStyle: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w500)
                                ),
                              ),

                              alignment: Alignment.centerLeft,
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, left: 30, right: 30, bottom: 20),
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                child: Text(
                                  'Description',
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xFF9E9E9E)),
                                  textAlign: TextAlign.left,
                                ),
                                padding: EdgeInsets.only(bottom: 15)),
                            Container(
                              child: Container(
                                child: TextFormField(
                                  controller: description,
                                  minLines: 2,
                                  maxLines: 2,
                                  keyboardType: TextInputType.streetAddress,
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                              child: Stack(children: [
                                Container(
                                  color: Color(0xFFF8F8F8),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: Image.asset('asset/image/Fill 1(3).png'))
                              ]),
                            )
                          ],
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          color: Color(0xffF4F4F4),
                          height: 50,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 30.0, right: 15.0),
                              child: Text(
                                'Due Date',
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xFF313131)),
                              ),
                            ),

                            ElevatedButton(
                                child: Text((showAnyTime)?"Anytime":DateFormat.yMd().format(focusedDay)), onPressed: () {setState(() {
                                  showCalendar=true;
                                });}),
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 30),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Add Member',
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xFF313131))),
                          SizedBox(height:10),
                          (memberList.isEmpty)?ElevatedButton(
                            child: Text("Anyone",
                                style: TextStyle(
                                    fontSize: 14, color: Color(0xFF313131))),
                            onPressed: () {
                              setState(() {
                                showMember=true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              // returns ButtonStyle
                              primary: Color(0xFFF4F4F4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                            ),
                          ):
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                List<QueryDocumentSnapshot<Object?>> data =
                                    snapshot.data!.docs;
                                return Row(
                                  children: [
                                    for (int i = 0; i < data.length; i++)
                                      if (memberList.contains(data[i]['index']))
                                        Padding(
                                          padding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                          child: Stack(
                                            children: [
                                              CircleAvatar(
                                                radius: 25,
                                               child: Image.asset(data[i]['link']),
                                              ),
                                              Positioned(
                                                top: 0,
                                                right: 0,
                                                child: InkWell(
                                                  onTap: () {setState(() {
                                                    memberList.remove(data[i]['index']);
                                                  });},
                                                  child:Container(height: 50,width: 50,)
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                    Container(
                                      width:  50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Color(0xFFF4F4F4),
                                          borderRadius: BorderRadius.circular(40)),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            showMember=true;
                                          });
                                        },
                                        child: Center(
                                            child: Text(
                                              '+',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return Container(
                                color: Colors.white,
                                child: Center(
                                  child: Image.asset(
                                    "assets/images/loader.gif",
                                  ),
                                ),
                              );
                            },
                          ),
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Center(
                        child: ConstrainedBox(
                            constraints:
                            BoxConstraints.tightFor(width: 300, height: 50),
                            child: ElevatedButton(
                                onPressed: addTask,
                                child: Text('Add Task'),
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFF96060),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ))),
                      ),
                    )
                  ]),
                )
              ])),

          if (showListUser) Padding(
            padding: const EdgeInsets.only(top: 195, bottom: 40, left: 20, right: 20),
            child: Container(color: Color(0xFFF4F4F4),
              width:MediaQuery.of(context).size.width,
              child: StreamBuilder(
                  stream:  users.orderBy('name').snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> users) {
                    if (!users.hasData) {
                      return Center(child: Text('Loading'));
                    }
                    return ListView(
                      children: users.data!.docs.map((users) {
                        return Center(
                          child: ListTile(leading: CircleAvatar(child: Image.asset(users['link'],),),
                            title: Text(users['name'],style:TextStyle(fontWeight:FontWeight.w500)),
                            subtitle: Text(users['subname']),
                            onTap: (){setState(() {
                              showListUser=false;
                              indexUser=users['index'];
                              showTextFieldUser=true;
                              getUser();
                            });},)
                        );
                      }).toList(),
                    );
                  }
              )
              ),
          ),
          if (showListProject) Padding(
            padding: const EdgeInsets.only(top: 195, bottom: 40, left: 20, right: 20),
            child: Container(color: Color(0xFFF4F4F4),
                width:MediaQuery.of(context).size.width,
                child: StreamBuilder(
                    stream:  projects.orderBy('name').snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> projects) {
                      if (!projects.hasData) {
                        return Center(child: Text('Loading'));
                      }
                      return ListView(
                        children: projects.data!.docs.map((projects) {
                          return Center(
                              child: ListTile(
                                title: Text(projects['name'],style:TextStyle(fontWeight:FontWeight.w500)),

                                onTap: (){

                                  setState(() {
                                    indexProject=projects['index'];
                                    showTextFieldProject=true;
                                    showListProject=false;
                                    getProject();
                                  });
                                },)
                          );
                        }).toList(),
                      );
                    }
                )
            ),
          ),
          if (showCalendar) Container(width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black.withOpacity(.5),
          ),
          if (showCalendar) Center(child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
            height: 430,
            width: 350,
            child: Column(children: [
              TableCalendar(
                focusedDay: DateTime.now(),
                firstDay: DateTime(1990),
                lastDay: DateTime(2050),
                calendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.monday,
                daysOfWeekVisible: true,
                onDaySelected: (DateTime selectDay, DateTime focusDay) {
                  setState(() {
                    selectedDay = selectDay;
                    focusedDay = focusDay;
                  });
                },
                selectedDayPredicate: (DateTime date) {
                  return isSameDay(selectedDay, date);
                },
                calendarStyle: CalendarStyle(
                  isTodayHighlighted: true,
                  selectedDecoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,

                  ),
                  selectedTextStyle: TextStyle(color: Colors.white),
                  todayDecoration: BoxDecoration(
                    color: Color(0xFF6074F9),
                    shape: BoxShape.circle,

                  ),
                  defaultDecoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  weekendDecoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(
                  child: ConstrainedBox(
                      constraints:
                      BoxConstraints.tightFor(width: 150, height: 40),
                      child: ElevatedButton(
                          onPressed: (){
                            setState(() {
                              showCalendar=false;
                              showAnyTime=false;
                            });
                          },
                          child: Text('Done'),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFF96060),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ))),
                ),
              )
            ],)
          )),
          if (showMember) Padding(
            padding: const EdgeInsets.only(top: 195, bottom: 40, left: 20, right: 20),
            child: Container(color: Color(0xFFF4F4F4),
                width:MediaQuery.of(context).size.width,
                child: StreamBuilder(
                    stream:  users.orderBy('name').snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> users) {
                      if (!users.hasData) {
                        return Center(child: Text('Loading'));
                      }
                      return ListView(
                        children: users.data!.docs.map((users) {
                          return Center(
                              child: ListTile(leading: CircleAvatar(child: Image.asset(users['link'],),),
                                title: Text(users['name'],style:TextStyle(fontWeight:FontWeight.w500)),
                                subtitle: Text(users['subname']),
                                onTap: (){setState(() {
                                  showMember=false;
                                  memberList.add(users['index']);
                                });},)
                          );
                        }).toList(),
                      );
                    }
                )
            ),
          ),

        ]));
  }
}
