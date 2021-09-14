import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_app/UI/CreateTask.dart';
import 'package:to_do_app/UI/CreateNode.dart';
import 'package:to_do_app/UI/CreateCheckList.dart';
import 'package:to_do_app/UI/Project.dart';
import 'package:to_do_app/UI/Quick.dart';
import 'package:to_do_app/UI/Profile.dart';
import 'package:to_do_app/UI/ViewTask.dart';
class WorkList extends StatefulWidget {
  final String userID;
  const WorkList({Key? key,required this.userID}):super(key:key);
  WorkListState createState() => WorkListState();
}

enum menu { AddTask, AddQuickNote, AddCheckList }

class OpacityFillPage extends StatelessWidget {
  const OpacityFillPage({
    Key? key,
    required this.press,
  }) : super(key: key);

  final Function press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        width: size.width,
        height: size.height,
        color: Colors.black.withOpacity(.4),
        // ignore: deprecated_member_use
        child: FlatButton(
          onPressed: () => press(),
          child: Container(),
        ),
      ),
    );
  }
}

class ToDoListFilter extends StatelessWidget {
  const ToDoListFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: 14,
        top: 70,
        child: Container(
          width: 230,
          height: 130,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Incomplete Tasks",
                      style: TextStyle(
                          fontFamily: 'AvenirNextRoundedPro',
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF313131),
                          decoration: TextDecoration.none),
                    ),
                    Spacer(),
                    Image.asset("asset/image/Fill 1 (1).png")
                  ],
                ),
                Text(
                  "Completed Tasks",
                  style: TextStyle(
                      fontFamily: 'AvenirNextRoundedPro',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF313131),
                      decoration: TextDecoration.none),
                ),
                Text(
                  "All Tasks",
                  style: TextStyle(
                      fontFamily: 'AvenirNextRoundedPro',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF313131),
                      decoration: TextDecoration.none),
                ),
              ],
            ),
          ),
        ));
  }
}

class WorkListState extends State<WorkList> {
  CalendarFormat format1 = CalendarFormat.week;
  bool _isFilter = false;
  bool _isAdd = false;
  void _targetAdd() {
    setState(() {
      _isAdd = true;
    });
  }
  void _nullTarger() {
    setState(() {
      _isFilter = false;
      _isAdd = false;
    });
  }
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
        break;
      case menu.AddCheckList:
      // ...
        Navigator.push(context, MaterialPageRoute(builder: (_)=>CreateCheckList(userID: widget.userID)));
        break;
      case null:
      // dialog dismissed
        break;
    }
  }

  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime time = DateTime.now();
    DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
    int x = 0;
    return Stack(
      children: [
        DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: Builder(builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xFFF96060),
                bottom: const TabBar(
                  tabs: [Tab(text: 'Today'), Tab(text: 'Month')],
                ),
                title: Text(
                  'Work List',
                  style: TextStyle(
                      fontFamily: "AvenirNextRoundedPro", fontSize: 28),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                      onPressed: () {
                        _targetAdd();
                      },
                      icon: Image.asset('asset/image/Page 1.png'))
                ],
              ),
              body: TabBarView(children: [
                ListView(padding: EdgeInsets.all(20.0), children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0.0),
                    child: Container(
                      child: Text('TODAY, '+now.day.toString()+"/"+now.month.toString()+"/"+now.year.toString()),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').doc(widget.userID).collection('task').snapshots(),
                    builder:
                        (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        List<QueryDocumentSnapshot<Object?>> data = snapshot.data!.docs;
                        List<QueryDocumentSnapshot<Object?>> nowData = [];
                        //final User? user = FirebaseAuth.instance.currentUser;
                        for (int i = 0; i < data.length; i++) {
                          if (now.millisecondsSinceEpoch <
                              DateTime.parse(data[i]['due date'].toString())
                                  .millisecondsSinceEpoch) {
                              nowData.add(data[i]);
                          }
                        }
                        return Column(
                          children: <Widget>[
                            for (int i = 0; i < nowData.length; i++)
                              if (nowData[i]['state'] != -1)
                                MyCard(userID: widget.userID,Project: nowData[i]['tag'],task: nowData[i]['tittle'],time: nowData[i]['due time'],checked: nowData[i]['state'],idTask: nowData[i]['taskID'].toString(),),
                            if (nowData.length == 0)
                              Center(
                                child: Text(
                                  "No task",
                                ),
                              ),
                          ],
                        );
                      }
                      return Container(
                        color: Colors.white,
                        child: Center(
                          child: Image.asset("assets/images/loader.gif"),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 8.0),
                    child: Container(
                      child: Text('TOMORROW, '+tomorrow.day.toString()+"/"+tomorrow.month.toString()+"/"+tomorrow.year.toString()),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').doc(widget.userID).collection('task').snapshots(),
                    builder:
                        (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        List<QueryDocumentSnapshot<Object?>> data = snapshot.data!.docs;
                        List<QueryDocumentSnapshot<Object?>> tomorrowData = [];
                        //final User? user = FirebaseAuth.instance.currentUser;
                        for (int i = 0; i < data.length; i++) {
                          if (tomorrow.millisecondsSinceEpoch <
                              DateTime.parse(data[i]['due date'].toString())
                                  .millisecondsSinceEpoch) {
                            tomorrowData.add(data[i]);
                          }
                        }
                        return Column(
                          children: <Widget>[
                            for (int i = 0; i < tomorrowData.length; i++)
                              if (tomorrowData[i]['state'] != -1)
                                MyCard(userID:widget.userID,Project:tomorrowData[i]['tag'],task: tomorrowData[i]['tittle'],time: tomorrowData[i]['due time'],checked: tomorrowData[i]['state'],idTask: tomorrowData[i]['taskID'].toString(),),
                            if (tomorrowData.length == 0)
                              Center(
                                child: Text(
                                  "No task",
                                ),
                              ),
                          ],
                        );
                      }
                      return Container(
                        color: Colors.white,
                        child: Center(
                          child: Image.asset("assets/images/loader.gif"),
                        ),
                      );
                    },
                  ),
                ]),
                ListView(padding: EdgeInsets.all(20.0), children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Container(
                      decoration:
                      BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(8.0, 8.0))
                      ]),
                      child: TableCalendar(
                        focusedDay: DateTime.now(),
                        firstDay: DateTime(1990),
                        lastDay: DateTime(2050),
                        calendarFormat: format1,
                        onFormatChanged: (_format) {
                          if (format1 != _format) {
                            setState(() {
                              format1 = _format;
                            });
                          }
                        },
                        startingDayOfWeek: StartingDayOfWeek.monday,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0.0),
                    child: Container(
                      child: Text('TODAY, '+now.day.toString()+"/"+now.month.toString()+"/"+now.year.toString()),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').doc(widget.userID).collection('task').snapshots(),
                    builder:
                        (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        List<QueryDocumentSnapshot<Object?>> data = snapshot.data!.docs;
                        List<QueryDocumentSnapshot<Object?>> nowData = [];
                        //final User? user = FirebaseAuth.instance.currentUser;
                        for (int i = 0; i < data.length; i++) {
                          if (now.millisecondsSinceEpoch <
                              DateTime.parse(data[i]['due date'].toString())
                                  .millisecondsSinceEpoch) {
                            nowData.add(data[i]);
                          }
                        }
                        return Column(
                          children: <Widget>[
                            for (int i = 0; i < nowData.length; i++)
                              if (nowData[i]['state'] != -1)
                                MyCard(userID:widget.userID,Project:nowData[i]['tag'],task: nowData[i]['tittle'],time: nowData[i]['due time'],checked: nowData[i]['state'],idTask: nowData[i]['taskID'].toString(),),
                            if (nowData.length == 0)
                              Center(
                                child: Text(
                                  "No task",
                                ),
                              ),
                          ],
                        );
                      }
                      return Container(
                        color: Colors.white,
                        child: Center(
                          child: Image.asset("assets/images/loader.gif"),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 8.0),
                    child: Container(
                      child: Text('TOMORROW, '+tomorrow.day.toString()+"/"+tomorrow.month.toString()+"/"+tomorrow.year.toString()),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').doc(widget.userID).collection('task').snapshots(),
                    builder:
                        (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        List<QueryDocumentSnapshot<Object?>> data = snapshot.data!.docs;
                        List<QueryDocumentSnapshot<Object?>> tomorrowData = [];
                        //final User? user = FirebaseAuth.instance.currentUser;
                        for (int i = 0; i < data.length; i++) {
                          if (tomorrow.millisecondsSinceEpoch <
                              DateTime.parse(data[i]['due date'].toString())
                                  .millisecondsSinceEpoch) {
                            tomorrowData.add(data[i]);
                          }
                        }
                        return Column(
                          children: <Widget>[
                            for (int i = 0; i < tomorrowData.length; i++)
                              if (tomorrowData[i]['state'] != -1)
                                MyCard(userID:widget.userID,Project: tomorrowData[i]['tag'],task: tomorrowData[i]['tittle'],time: tomorrowData[i]['due time'],checked: tomorrowData[i]['state'],idTask: tomorrowData[i]['taskID'].toString(),),
                            if (tomorrowData.length == 0)
                              Center(
                                child: Text(
                                  "No task",
                                ),
                              ),
                          ],
                        );
                      }
                      return Container(
                        color: Colors.white,
                        child: Center(
                          child: Image.asset("assets/images/loader.gif"),
                        ),
                      );
                    },
                  ),
                ]),
              ]),
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
                              icon:
                              Icon(Icons.check_circle, color: Colors.white),
                              iconSize: 30,
                              onPressed: () {},
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Text('My Task',
                                style: TextStyle(color: Colors.white)),
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
                                icon: Image.asset('asset/image/Page 1 (4).png'),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_)=>Profile(userID:widget.userID)));
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Text('Profile',
                                style: TextStyle(color: Color(0xff8E8E93))),
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
              floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
            );
          }),
        ),
        if (_isAdd) OpacityFillPage(press: _nullTarger),
        if (_isAdd) ToDoListFilter(),

      ],
    );
  }
}
class MyCard extends StatelessWidget{
  const MyCard({
    Key? key,
    required this.task,
    required this.time,
    required this.checked,
    required this.idTask,
    required this.Project,
    required this.userID
  }) : super(key: key);

  final String task, time, idTask,Project;
  final int checked;
  final String userID;
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: Container(
          decoration:
          BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(8.0, 8.0))
          ]),
          //color: Colors.green,
          child: ListTile(
            leading:(checked==1)?Icon(Icons.check_circle_rounded,color: Colors.red,):Icon(Icons.circle_outlined,color:Colors.blue),
            title: (checked==1)?
            Text(
              task,
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.lineThrough,
                  color: Color(0xff9E9E9E)),
              overflow: TextOverflow.ellipsis,
            ):
            Text(task,
                style: TextStyle(
                    fontSize: 19, fontWeight: FontWeight.w500)),
            subtitle: (checked==1)?
            Text(
              time,
              style: TextStyle(
                  fontSize: 18,
                  decoration: TextDecoration.lineThrough,
                  color: Color(0xff9E9E9E)),
            ):
            Text(
              time,
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        actions: <Widget>[],
        secondaryActions: <Widget>[
          SlideAction(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Container(
                  child: Image.asset('asset/image/Fill 1(1).png'),
                ),
                VerticalDivider(
                  width: 1,
                  color: Color(0xff000000),
                ),
              ],
            ),
            color: Colors.white,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ViewTask(idTask: idTask)));
            },
          ),
          SlideAction(
            child: Container(
                child: Image.asset('asset/image/Page 1 (1).png')),
            color: Colors.white,
            onTap: ()async{
               int index=-1;
              int taskProject=0;
              await FirebaseFirestore.instance
                  .collection('users').doc(userID).collection('project')
                  .get()
                  .then((QuerySnapshot querySnapshot) {
                querySnapshot.docs.forEach((doc) {
                  if (doc['name']==Project)
                  {
                    index=doc['index'];
                    taskProject=doc['task'];
                  }
                });
              });
              await FirebaseFirestore.instance.collection('users')
                  .doc(userID)
                  .collection('task')
                  .doc(idTask)
                  .update({'state':-1});
              await FirebaseFirestore.instance.collection('users')
              .doc(userID)
              .collection('project').doc(index.toString()).update({'task':taskProject-1});
            },

          ),

        ],
      ),
    );
  }
}