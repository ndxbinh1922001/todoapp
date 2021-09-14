import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_app/UI/Profile.dart';
import 'package:to_do_app/UI/Project.dart';
import 'package:to_do_app/UI/WorkList.dart';
import 'package:to_do_app/UI/CreateTask.dart';
import 'package:to_do_app/UI/CreateNode.dart';
import 'package:to_do_app/UI/CreateCheckList.dart';
class Quick extends StatefulWidget {
  final String userID;
  const Quick({Key? key,required this.userID}):super(key:key);
  QuickState createState() => QuickState();
}
enum menu { AddTask, AddQuickNote, AddCheckList }
class QuickState extends State<Quick> {

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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xFFFDFDFD),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0), // here the desired height
        child: AppBar(
          leading: null,
          centerTitle: true,
          backgroundColor: Color(0xFFFFFFFF),
          bottomOpacity: 10.0,
          title: Text('Quick Notes',
              style: TextStyle(
                  fontSize: 22,
                  color: Color(0xFF313131),
                  fontWeight: FontWeight.w500)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 25),
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.only(left:5.0,right:5),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(widget.userID).collection('note').snapshots(),
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot<Object?>> data = snapshot.data!.docs;
                  List<QueryDocumentSnapshot<Object?>> nowData = [];
                  //final User? user = FirebaseAuth.instance.currentUser;
                  for (int i = 0; i < data.length; i++) {
                      nowData.add(data[i]);
                  }
                  return Column(
                    children: <Widget>[
                      for (int i = 0; i < nowData.length; i++)
                        cardNode(description: nowData[i]['description'], color: int.parse(nowData[i]['color'])),
                      if (nowData.length == 0)
                        Center(
                          child: Text(
                            "No note",
                          ),
                        ),
                    ],
                  );
                }
                return Container(
                  color: Colors.white,
                  child: Center(
                    child: Image.asset("asset/image/loader.gif"),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left:5.0,right:5),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(widget.userID).collection('checklist').snapshots(),
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot<Object?>> data = snapshot.data!.docs;
                  List<QueryDocumentSnapshot<Object?>> listItem = [];
                  //final User? user = FirebaseAuth.instance.currentUser;
                  for (int i = 0; i < data.length; i++) {
                    listItem.add(data[i]);
                  }
                  return Column(
                    children: <Widget>[
                      for (int i = 0; i < listItem.length; i++)
                          ListCheckItem(note: listItem[i]['tittle'], color: Color(int.parse(listItem[i]['color'])),
                              listNote: [
                                for (int j = 0; j < data[i]['length']; j++)
                                  data[i]['item$j'],
                              ], checkListNote: [
                                for (int j = 0; j < data[i]['length']; j++)
                                  data[i]['checked$j'],
                              ], press: (index) => {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.userID)
                                  .collection("checklist")
                                  .doc(data[i]["id"].toString())
                                  .update({
                                'checked$index': true,
                              })
                            },),
                      if (listItem.length == 0)
                        Center(
                          child: Text(
                            "",
                          ),
                        ),
                    ],
                  );
                }
                return Container(
                  color: Colors.white,
                  child: Center(
                    child: Image.asset("asset/image/loader.gif"),
                  ),
                );
              },
            ),
          ),
          SizedBox(height:30)

        ]),
      ),
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
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>WorkList(userID: widget.userID)));
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
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>Projects(userID: widget.userID)));
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
                        icon: Image.asset('asset/image/Page1.png'),
                        onPressed: () {

                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text('Quick', style: TextStyle(color: Colors.white)),
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
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>Profile(userID: widget.userID)));
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
class cardNode extends StatelessWidget{
  final String description;
  final int color;
  const cardNode({Key? key,required this.description,required this.color}): super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(padding: EdgeInsets.only(top:12,bottom:12),
    child: Stack(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(2.0, 2.0))
        ]),
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 32,right: 32),
          child: Text(
            description + "\n",
            style: TextStyle(
                fontSize: 18,
                fontFamily: 'AvenirNextRoundedPro',
                fontWeight: FontWeight.w600,
                height: 1.8),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 32.0),
        child: Container(width: 121, height: 3, color: Color(color)),
      )
    ]),);
  }
}
//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_0_stroke.color = Color(0xff979797).withOpacity(1.0);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
            Rect.fromLTWH(size.width * 0.04166667, size.height * 0.04166667,
                size.width * 0.9166667, size.height * 0.9166667),
            bottomRight: Radius.circular(size.width * 0.2083333),
            bottomLeft: Radius.circular(size.width * 0.2083333),
            topLeft: Radius.circular(size.width * 0.2083333),
            topRight: Radius.circular(size.width * 0.2083333)),
        paint_0_stroke);

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
            Rect.fromLTWH(size.width * 0.04166667, size.height * 0.04166667,
                size.width * 0.9166667, size.height * 0.9166667),
            bottomRight: Radius.circular(size.width * 0.2083333),
            bottomLeft: Radius.circular(size.width * 0.2083333),
            topLeft: Radius.circular(size.width * 0.2083333),
            topRight: Radius.circular(size.width * 0.2083333)),
        paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class RPSCustomPainterFull extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_0_stroke.color = Color(0xff979797).withOpacity(1.0);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
            Rect.fromLTWH(size.width * 0.04166667, size.height * 0.04166667,
                size.width * 0.9166667, size.height * 0.9166667),
            bottomRight: Radius.circular(size.width * 0.2083333),
            bottomLeft: Radius.circular(size.width * 0.2083333),
            topLeft: Radius.circular(size.width * 0.2083333),
            topRight: Radius.circular(size.width * 0.2083333)),
        paint_0_stroke);

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xff979797).withOpacity(1.0);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
            Rect.fromLTWH(size.width * 0.04166667, size.height * 0.04166667,
                size.width * 0.9166667, size.height * 0.9166667),
            bottomRight: Radius.circular(size.width * 0.2083333),
            bottomLeft: Radius.circular(size.width * 0.2083333),
            topLeft: Radius.circular(size.width * 0.2083333),
            topRight: Radius.circular(size.width * 0.2083333)),
        paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
class ListCheckItem extends StatelessWidget {
  const ListCheckItem({
    Key? key,
    required this.note,
    required this.color,
    required this.listNote,
    required this.checkListNote,
    required this.press,
  }) : super(key: key);

  final String note;
  final Color color;
  final List<String> listNote;
  final List<bool> checkListNote;
  final Function press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top:12,bottom:12),
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(2.0, 2.0)
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Container(
                width: 121,
                height: 3,
                color: color,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 21,
                left: 32,
                right: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 30 / 16,
                    ),
                  ),
                  for (int i = 0; i < checkListNote.length; i++)
                    NoteIcon(
                      index: i,
                      text: listNote[i],
                      check: checkListNote[i],
                      press: press,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  InkWell NoteIcon(
      {required int index,
        required String text,
        required bool check,
        required Function press}) {
    return InkWell(
      onTap: () => press(index),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: check ? Color(0xFF979797) : Colors.white,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(
                  color: Color(0xFF979797),
                ),
              ),
            ),
          ),
          SizedBox(width: 11),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              height: 30 / 16,
              fontWeight: FontWeight.w400,
              decoration:
              check ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          )
        ],
      ),
    );
  }


}