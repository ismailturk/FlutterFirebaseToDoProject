


import 'package:flutter/material.dart';
import 'package:todo_firebase/kayitformu.dart';

class KayitEkrani extends StatefulWidget {
  const KayitEkrani({Key? key}) : super(key: key);

  @override
  _KayitEkraniState createState() => _KayitEkraniState();
}

class _KayitEkraniState extends State<KayitEkrani> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text("Kayıt Ekranı",style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: KayitFormu(),
    );
  }
}
