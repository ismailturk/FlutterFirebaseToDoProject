import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GorevEke extends StatefulWidget {
  const GorevEke({Key? key}) : super(key: key);

  @override
  _GorevEkeState createState() => _GorevEkeState();
}

class _GorevEkeState extends State<GorevEke> {

  //verileri kontrollerden alıcı

  TextEditingController taskHolder=TextEditingController();
  TextEditingController dateHolder=TextEditingController();










  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Add Task"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 30, 8, 8),
            child: TextFormField(
              controller: taskHolder,
              decoration: InputDecoration(
                  labelText: "Enter task", border: OutlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: dateHolder,
              decoration: InputDecoration(
                  labelText: "Deadline", border: OutlineInputBorder()),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            height: 70,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // tıklayınca firebase e ekleme yapacak

                addData();

              },
              child: Text("Add Task"),
              style: ElevatedButton.styleFrom(primary: Colors.teal),
            ),
          )
        ],
      ),
    );
  }

   addData() async{

    FirebaseAuth Auth =  FirebaseAuth.instance;
    User? currentFirebaseUser = Auth.currentUser;//stackoverflowdan alındı!!!!!!!


     String uidHolder=currentFirebaseUser!.uid; //!!!!!!!!!!!!!!!!!
     var timeHolder=DateTime.now();
     
     await FirebaseFirestore.instance.collection("Tasks").doc(uidHolder).collection("My Tasks").doc(timeHolder.toString()).set({"Task Name":taskHolder.text,"Deadline":dateHolder.text,"Date":timeHolder.toString(),"All Date":timeHolder});

      Fluttertoast.showToast(msg: "Task added!!");


  }
}
