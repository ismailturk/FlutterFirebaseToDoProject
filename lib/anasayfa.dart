import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:todo_firebase/gorevekle.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({Key? key}) : super(key: key);

  @override
  _AnasayfaState createState() => _AnasayfaState();
}
var currentUserUidHolder;

class _AnasayfaState extends State<Anasayfa> {


  @override //ilk sayfa açıldıgında yapılır!!!!!
  void initState() {
    takeCurrentUserUid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To Do List"),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(
            onPressed: () async{
               await FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Tasks")
              .doc(currentUserUidHolder)
              .collection("My Tasks")
              .snapshots(),
          builder: (context, AsyncSnapshot databaseData) {
            if (databaseData.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final receivedData = databaseData.data.docs;

              return ListView.builder(
                  itemCount: receivedData.length,
                  itemBuilder: (context, index) {
                    var addedTime =
                        (receivedData[index]["All Date"] as Timestamp).toDate();

                    return Container(
                      height: 70,
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                      decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  receivedData[index]["Task Name"],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  DateFormat.yMd()
                                      .add_jm()
                                      .format(addedTime)
                                      .toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(receivedData[index]["Deadline"],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            IconButton(
                              onPressed: () async {
                                FirebaseFirestore.instance
                                    .collection("Tasks")
                                    .doc(currentUserUidHolder)
                                    .collection("My Tasks")
                                    .doc(receivedData[index]["Date"])
                                    .delete();
                                Fluttertoast.showToast(msg: "Task deleted");
                              },
                              icon: Icon(Icons.delete),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // görev ekleme sayafsına git
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => GorevEke()));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }

  void takeCurrentUserUid() async {
    FirebaseAuth Auth = FirebaseAuth.instance;
    User? currentFirebaseUser = Auth.currentUser;

    setState(() {
      currentUserUidHolder = currentFirebaseUser!.uid;
    });
  }
}
