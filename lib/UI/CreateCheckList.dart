import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_app/Route/route.dart';
import 'package:to_do_app/UI/CreateTask.dart';
import 'package:to_do_app/UI/CreateNode.dart';
import 'package:to_do_app/UI/CreateCheckList.dart';
class CreateCheckList extends StatefulWidget {
  final String userID;
  const CreateCheckList({Key? key,required this.userID}):super(key:key);
  CreateCheckListState createState() => CreateCheckListState();
}
enum menu { AddTask, AddQuickNote, AddCheckList }
class CreateCheckListState extends State<CreateCheckList> {
  int indexItem=4;
  List<TextEditingController> listItem=[for(int i=0;i<10;i++)TextEditingController()];
  var description=TextEditingController();
  int indexChooseColor = 0;
  void _setColor(int index) {
    setState(() {
      indexChooseColor = index;
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
  Future<void> addNote () async {
    int length=0;
    int index=0;
    int task=0;
    await FirebaseFirestore.instance
        .collection('users').doc(widget.userID).collection('note')
        .get()
        .then((snap) {
      length = snap
          .docs.length; // will return the collection size
    });
    await FirebaseFirestore.instance.collection('users').doc(widget.userID).collection('note').doc("${length+1}")
        .set({
      'description':description.text.trim().toString(),
      'color': (indexChooseColor == 0)
          ? "0xFF6074F9"
          : (indexChooseColor == 1)
          ? "0xFFE42B6A"
          : (indexChooseColor == 2)
          ? "0xFF5ABB56"
          : (indexChooseColor == 3)
          ? "0xFF3D3A62"
          : "0xFFF4CA8F"
    }).catchError((error) => print("Failed to add user: $error"));
    Navigator.pop(context);
  }
  @override
  // TODO: implement context
  Widget build(BuildContext context) {
    return Material(child:Stack(children: [
      DefaultTabController(
          length: 0,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFFF96060),
              leading: IconButton(
                  icon: Image.asset('asset/image/Fill 1(2).png'),
                  onPressed: () {
                    // Do something.
                  }),
              bottom: TabBar(
                tabs: [],
              ),
              title: Text(
                'Add Check List',
                style:
                TextStyle(fontFamily: "AvenirNextRoundedPro", fontSize: 28),
              ),
              centerTitle: true,
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
                            onPressed: () {},
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
                                Navigator.of(context).pushNamed('/Projects');
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
                                Navigator.of(context).pushNamed('/Quick');
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
                                Navigator.of(context).pushNamed('/Profile');
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
          )),
      Padding(
          padding:
          const EdgeInsets.only(top: 150, bottom: 120, left: 20, right: 20),
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
                padding: const EdgeInsets.only(top: 24.0, left: 24.0,right:24),
                child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tittle',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'AvenirNextRoundedPro',
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF313131),decoration: TextDecoration.none)),
                      SizedBox(height:11),
                      Container(width:MediaQuery.of(context).size.width,
                        color:Colors.white,
                        child:Material(child: TextFormField(
                          controller: description,
                          keyboardType: TextInputType.streetAddress,
                          cursorColor: Colors.black,
                          style: TextStyle(decoration: TextDecoration.none,color:Colors.black),
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                            hintStyle: TextStyle(color:Color(0xFF313131)),
                            contentPadding: EdgeInsets.all(0.0),),

                          minLines: 2,
                          maxLines: 2,
                        )),),
                      SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        for(int i=0;i<indexItem;i++)
                          ListItem(index: i,controller:listItem[i] ,),
                          SizedBox(height: 12,),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (indexItem < 10)
                                indexItem++;
                            });
                          },
                          child: Text(
                            "+ Add new item",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                          SizedBox(height: 12,)
                      ],),),
                      Text('Choose Color',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'AvenirNextRoundedPro',
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF313131),decoration: TextDecoration.none)),
                      SizedBox(height:11),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 17,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (int i = 0; i < 5; i++)
                              ChooseColorIcon(
                                index: i,
                                press: _setColor,
                                tick: i == indexChooseColor,
                              )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Center(
                          child: ConstrainedBox(
                              constraints:
                              BoxConstraints.tightFor(width: 300, height: 50),
                              child: ElevatedButton(
                                  onPressed: ()async{
                                    int length=0;
                                    await FirebaseFirestore.instance
                                        .collection('users').doc(widget.userID).collection('checklist')
                                        .get()
                                        .then((snap) {
                                      length = snap
                                          .docs.length; // will return the collection size
                                    });
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(widget.userID)
                                        .collection("checklist").doc("${length+1}")
                                        .set({
                                      'tittle': description.text.trim(),
                                    'color': (indexChooseColor == 0)
                                    ? "0xFF6074F9"
                                        : (indexChooseColor == 1)
                                    ? "0xFFE42B6A"
                                        : (indexChooseColor == 2)
                                    ? "0xFF5ABB56"
                                        : (indexChooseColor == 3)
                                    ? "0xFF3D3A62"
                                        : "0xFFF4CA8F",
                                      'list': true,
                                      'length': indexItem,
                                      for (int i = 0 ; i< indexItem; i++)
                                        'item$i': listItem[i].text.trim(),
                                      for (int i = 0 ; i< indexItem; i++)
                                        'checked$i': false,
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text('Done'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFFF96060),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ))),
                        ),
                      ),
                      SizedBox( height:20)
                    ]),))
          ])),
    ]) ,)
    ;
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
class ListItem extends StatelessWidget {
  const ListItem({
    Key? key,
    required this.index,
    required this.controller,
  }) : super(key: key);

  final int index;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Color(0xFFF4F4F4),
              borderRadius: BorderRadius.circular(3),
              border: Border.all(
                color: Color(0xFF979797),
              ),
            ),
          ),
          SizedBox(width: 14),
          Container(
            width: size.width * .4,
            height: 40,
            child: TextFormField(
              controller: controller,
              validator: (val) => val!.isNotEmpty
                  ? null
                  : "Please enter list item",
              decoration: InputDecoration(
                hintText: "List Item ${index + 1}",
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}