import 'package:flutter/material.dart';
import 'package:to_do_app/Route/route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do_app/UI/CreateTask.dart';
import 'package:to_do_app/UI/CreateNode.dart';
import 'package:to_do_app/UI/CreateCheckList.dart';
import 'package:to_do_app/UI/DetailProject.dart';
import 'package:to_do_app/UI/Profile.dart';
import 'package:to_do_app/UI/Quick.dart';
import 'package:to_do_app/UI/WorkList.dart';

class Projects extends StatefulWidget {
  final String userID;
  const Projects({Key? key, required this.userID}):super(key:key);
  @override
  ProjectState createState() => ProjectState();
}

enum menu { AddTask, AddQuickNote, AddCheckList }

class cardMyApp12 extends StatelessWidget {
  const cardMyApp12({
    Key? key,
    required this.color1,
    required this.color2,
    required this.text1,
    required this.text2,
    required this.userID,
  }) : super(key: key);
  final int color1;
  final int color2;
  final String text1;
  final String text2;
  final String userID;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(child: Container(
      color: Colors.white,
      width: 160,
      height: 170,
      child: Padding(
        padding: const EdgeInsets.only(left: 24, top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: CustomPaint(
                painter: MyPainter(color1: color1, color2: color2),
                child: SizedBox(width: 30, height: 30),
              ),
            ),
            Text(text1,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF313131))),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 5),
              child: Text(text2,
                  style: TextStyle(fontSize: 14, color: Color(0xFF9A9A9A))),
            )
          ],
        ),
      ),
    ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetailProject(userID:userID,name:text1,color: color2,)));
        }
    );
  }
}
class MyPainter extends CustomPainter {
  final int color1;
  final int color2;

  const MyPainter({required this.color1, required this.color2});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    // Path number 1

    paint.color = Color(color1);
    path = Path();
    path.lineTo(size.width, size.height / 2);
    path.cubicTo(size.width, size.height * 0.78, size.width * 0.78, size.height,
        size.width / 2, size.height);
    path.cubicTo(size.width * 0.22, size.height, 0, size.height * 0.78, 0,
        size.height / 2);
    path.cubicTo(
        0, size.height * 0.22, size.width * 0.22, 0, size.width / 2, 0);
    path.cubicTo(size.width * 0.78, 0, size.width, size.height * 0.22,
        size.width, size.height / 2);
    canvas.drawPath(path, paint);

    // Path number 2

    paint.color = Color(color2);
    path = Path();
    path.lineTo(size.width * 0.77, size.height / 2);
    path.cubicTo(size.width * 0.77, size.height * 0.65, size.width * 0.65,
        size.height * 0.77, size.width / 2, size.height * 0.77);
    path.cubicTo(size.width * 0.35, size.height * 0.77, size.width * 0.23,
        size.height * 0.65, size.width * 0.23, size.height / 2);
    path.cubicTo(size.width * 0.23, size.height * 0.35, size.width * 0.35,
        size.height * 0.23, size.width / 2, size.height * 0.23);
    path.cubicTo(size.width * 0.65, size.height * 0.23, size.width * 0.77,
        size.height * 0.35, size.width * 0.77, size.height / 2);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

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

class ProjectState extends State<Projects> {
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
        // ...
        Navigator.push(context, MaterialPageRoute(builder: (_)=>CreateNode(userID: widget.userID)));
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

  bool _onCard = false;

  void _setCard() {
    setState(() {
      _onCard = !_onCard;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0), // here the desired height
            child: AppBar(
              leading: null,
              centerTitle: true,
              backgroundColor: Color(0xFFFFFFFF),
              bottomOpacity: 10.0,
              title: Text('Projects',
                  style: TextStyle(
                      fontSize: 22,
                      color: Color(0xFF313131),
                      fontWeight: FontWeight.w500)),
            ),
          ),
          body: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.userID)
                      .collection('project')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      List<QueryDocumentSnapshot<Object?>> data =
                          snapshot.data!.docs;
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            for (int i = 0; i <= data.length / 2; i++)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        (i * 2 < data.length)
                                            ? cardMyApp12(
                                            userID: widget.userID,
                                                color1: int.parse(
                                                    data[i * 2]['color1']),
                                                color2: int.parse(
                                                    data[i * 2]['color2']),
                                                text1: data[i * 2]['name'],
                                                text2:
                                                    "${data[i * 2]['task']} task")
                                            : Row(children: [
                                          AddProjectButton(userID: widget.userID,),Container(width: 160,height: 170,)
                                        ],),
                                        if (i * 2 + 1 < data.length)
                                          cardMyApp12(
                                            userID:widget.userID,
                                              color1: int.parse(
                                                  data[i * 2 + 1]['color1']),
                                              color2: int.parse(
                                                  data[i * 2 + 1]['color2']),
                                              text1: data[i * 2 + 1]['name'],
                                              text2:
                                                  "${data[i * 2 + 1]['task']} task"),
                                        if (i * 2 < data.length &&
                                            i * 2 + 1 >= data.length)
                                          AddProjectButton(userID: widget.userID,)
                                      ],
                                    ),
                                    SizedBox(height: 10)
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    }
                    return Container(
                      color: Colors.white,
                      child: Center(),
                    );
                  })),
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
                            icon: Image.asset('asset/image/Page 1 (6).png'),
                            iconSize: 30,
                            onPressed: () {}),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child:
                            Text('Menu', style: TextStyle(color: Colors.white)),
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
        ),

      ],
    );
  }
}

class AddProjectButton extends StatelessWidget {
  final String userID;
  const AddProjectButton({
    Key? key, required this.userID
  }) : super(key: key);
  Future<void> showAddProjectDialog(BuildContext context) async {
    Size size = MediaQuery.of(context).size;
    int indexChooseColor = 0;
    final _formKey = GlobalKey<FormState>();
    TextEditingController _projectController = TextEditingController();
    return await showDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          void _setColor(int index) {
            setState(() {
              indexChooseColor = index;
            });
          }

          return AlertDialog(
            contentPadding: EdgeInsets.all(24),
            content: Container(
              width: size.width,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Title",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(border: InputBorder.none),
                      validator: (val) =>
                      val!.isNotEmpty ? null : 'Please enter your text',
                      controller: _projectController,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Choose Color",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        for (int i = 0; i < 5; i++)
                          ChooseColorIcon(
                            index: i,
                            press: _setColor,
                            tick: i == indexChooseColor,
                          ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Center(
                        child: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: 150, height: 40),
                            child: ElevatedButton(
                                onPressed: () async {
                                  int size = 0;
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(userID)
                                      .collection("project")
                                      .get()
                                      .then((snap) {
                                    size = snap.docs
                                        .length; // will return the collection size
                                  });
                                  if (_formKey.currentState!.validate()) {
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(userID)
                                        .collection("project")
                                        .doc('${size + 1}')
                                        .set({
                                      'name': _projectController.text.trim(),
                                      'color2': (indexChooseColor == 0)
                                          ? "0xFF6074F9"
                                          : (indexChooseColor == 1)
                                          ? "0xFFE42B6A"
                                          : (indexChooseColor == 2)
                                          ? "0xFF5ABB56"
                                          : (indexChooseColor == 3)
                                          ? "0xFF3D3A62"
                                          : "0xFFF4CA8F",
                                      'color1': (indexChooseColor == 0)
                                          ? "0xFFDBDDEF"
                                          : (indexChooseColor == 1)
                                          ? "0xFFE8C7D2"
                                          : (indexChooseColor == 2)
                                          ? "0xFFD4F1D3"
                                          : (indexChooseColor == 3)
                                          ? "0xFFF9DFFB"
                                          : "0xFF9E9E9E",
                                      'task': 0,
                                      'index': size + 1
                                    });
                                    Navigator.pop(context);
                                  }
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
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
  @override
  Widget build(BuildContext context) {


    return SizedBox(
      width: 160,
      height: 170,
      child: Center(
        child: InkWell(
          onTap:(){showAddProjectDialog(context);},
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color(0xFF6074F9),
            ),
            child: Center(
              child: Text(
                "+",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChooseColorIcon extends StatelessWidget {
  const ChooseColorIcon({
    Key? key,
    this.tick = false,
    required this.index,
    required this.press,
  }) : super(key: key);
  final bool tick;
  final int index;
  final Function press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<int> _color = [
      0xFF6074F9,
      0xFFE42B6A,
      0xFF5ABB56,
      0xFF3D3A62,
      0xFFF4CA8F,
    ];
    return InkWell(
      onTap: () => press(index),
      child: Container(
        width: size.width * .12,
        height: size.width * .12,
        decoration: BoxDecoration(
            color: Color(_color[index]),
            borderRadius: BorderRadius.circular(5)),
        child: Center(
            child: SvgPicture.asset(
          "asset/image/tick.svg",
          color: Colors.white.withOpacity(tick ? 1 : 0),
        )),
      ),
    );
  }
}
