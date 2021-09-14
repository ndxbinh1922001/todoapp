import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ViewTask extends StatefulWidget {
  const ViewTask({required this.idTask});

  final String idTask;

  ViewTaskState createState() => ViewTaskState();
}

class ViewTaskState extends State<ViewTask> {
  bool showComment=false;
  bool showSetting=false;
  CollectionReference users = FirebaseFirestore.instance
      .collection('users')
      .doc("1")
      .collection('task');

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.idTask).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          List<int> memberList = new List<int>.from(data["member"]);
          return Material(
            child: Stack(children: [
              Scaffold(
                backgroundColor: Color(0xFFF96060),
                bottomNavigationBar: SizedBox(
                  height: 70.0,
                  child: BottomAppBar(
                    color: Color(0xff292E4E),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                      top: 70, bottom: 30, left: 20, right: 20),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                      child:SingleChildScrollView(
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.close)),
                                IconButton(onPressed: () {setState(() {
                                  showSetting=!showSetting;
                                });}, icon: Icon(Icons.settings))
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20, bottom: 20),
                              child: Text(
                                data['tittle'],
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w500),
                              ),
                            ),
                            ListTile(
                                leading: Image.asset(data['link']),
                                title: Text("Assigned to",
                                    style: TextStyle(
                                        fontSize: 16, color: Color(0xFF9A9A9A))),
                                subtitle: Text(
                                  data['user'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0, right: 30),
                              child: Divider(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: ListTile(
                                leading: Icon(Icons.calendar_today_outlined),
                                title: Text("Due date",
                                    style: TextStyle(
                                        fontSize: 16, color: Color(0xFF9A9A9A))),
                                subtitle: Text(
                                    DateFormat.yMMMd()
                                        .format(DateTime.parse(data['due date'])),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0, right: 30),
                              child: Divider(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: ListTile(
                                leading: Icon(Icons.description_outlined),
                                title: Text("Description",
                                    style: TextStyle(
                                        fontSize: 16, color: Color(0xFF9A9A9A))),
                                subtitle: Text(data['description'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0, right: 30),
                              child: Divider(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: ListTile(
                                leading: Icon(Icons.people_outline),
                                title: Text("Description",
                                    style: TextStyle(
                                        fontSize: 16, color: Color(0xFF9A9A9A))),
                                subtitle: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .snapshots(),
                                  builder:
                                      (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      List<QueryDocumentSnapshot<Object?>> data1 =
                                          snapshot.data!.docs;
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Row(
                                          children: [
                                            for (int i = 0; i < data1.length; i++)
                                              if (memberList
                                                  .contains(data1[i]['index']))
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 5,
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 25,
                                                        child: Image.asset(
                                                            data1[i]['link']),
                                                      ),
                                                      Positioned(
                                                        top: 0,
                                                        right: 0,
                                                        child: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                memberList.remove(
                                                                    data1[i]['index']);
                                                              });
                                                            },
                                                            child: Container(
                                                              height: 50,
                                                              width: 50,
                                                            )),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                          ],
                                        ),
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
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0, right: 30),
                              child: Divider(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0,right:20),
                              child: ListTile(
                                leading: Image(
                                  image: AssetImage("asset/image/icon.png"),
                                ),
                                title: Text("Tag",
                                    style: TextStyle(
                                        fontSize: 16, color: Color(0xFF9A9A9A))),
                                subtitle: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 40,
                                        child: Center(
                                          child: Text("  " + data['tag'] + "  ",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.blue,
                                              )),
                                        ),
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey)),
                                      ),
                                      Expanded(child: Container())
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if(showComment)Padding(
                              padding: const EdgeInsets.only(left:20.0,right: 20,top:30),
                              child: Container(
                                child: Container(
                                  child: TextFormField(

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
                            ),
                            if(showComment)Padding(
                              padding: const EdgeInsets.only(left: 20.0,right:20),
                              child: SizedBox(
                                height: 40,
                                child: Stack(children: [
                                  Container(
                                    color: Color(0xFFF8F8F8),
                                  ),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(children: [
                                        IconButton(onPressed: (){}, icon: Icon(Icons.broken_image_outlined ,color:Colors.grey)),
                                        IconButton(
                                            onPressed: () {},
                                            icon: Image.asset('asset/image/Fill 1(3).png'))
                                      ],),
                                      TextButton(onPressed: (){}, child:Text("Send",style: TextStyle(color:Colors.blue),) )
                                    ],)
                                ]),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0,bottom:10),
                              child: Center(
                                child: ConstrainedBox(
                                    constraints:
                                    BoxConstraints.tightFor(width: 300, height: 50),
                                    child: ElevatedButton(
                                        onPressed: (){
                                          FirebaseFirestore.instance.collection('users').doc("1")
                                              .collection('task').doc(widget.idTask).update({"state":1});
                                          Navigator.pop(context);
                                        },
                                        child: Text('Complete Task',style: TextStyle(fontSize: 20),),
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFF6074F9),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                          ),
                                        ))),
                              ),
                            ),
                            if(!showComment)InkWell(onTap: (){
                              setState(() {
                                showComment=true;
                              });
                            },
                              child: Image.asset("asset/image/Group 18.png"),),
                            SizedBox(height: 30,)
                          ])
                      )
                  )),
              if(showSetting) OpacityFillPage(press: (){setState(() {
                showSetting=!showSetting;
              });},),
              if(showSetting) ToDoListFilter()
            ]),
          );
        }

        return Center(child: Text("loading..."));
      },
    );
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
                Text(
                  "Add to Project",
                  style: TextStyle(
                      fontFamily: 'AvenirNextRoundedPro',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF313131),
                      decoration: TextDecoration.none),
                ),
                Text(
                  "Add Member",
                  style: TextStyle(
                      fontFamily: 'AvenirNextRoundedPro',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF313131),
                      decoration: TextDecoration.none),
                ),
                Text(
                  "Delete Tasks",
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
