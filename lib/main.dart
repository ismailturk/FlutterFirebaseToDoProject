import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_firebase/anasayfa.dart';
import 'package:todo_firebase/kayitekrani.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
  runApp(const Todo());
}


class Todo extends StatelessWidget {
  const Todo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home:StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder:(context,userData){
            if(userData.hasData){
              return Anasayfa();
            }
            else{
              return KayitEkrani();
            }
          },
        ),

      );
  }
}




