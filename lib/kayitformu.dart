import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KayitFormu extends StatefulWidget {
  const KayitFormu({Key? key}) : super(key: key);

  @override
  _KayitFormuState createState() => _KayitFormuState();
}
bool registerState = false;
  var username, email, password;

class _KayitFormuState extends State<KayitFormu> {



  var _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Image.asset(
              "images/todo2.jpg",
              height: 250,
              width: 250,
            ),
            if (!registerState)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  onChanged: (receivedUsername) {
                    username = receivedUsername;
                  },
                  validator: (receivedUsername) {
                    return receivedUsername!.isEmpty ? "cannot be empty" : null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter your username"),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (receivedEmail) {
                  email = receivedEmail;
                },
                validator: (receivedEmail) {
                  return receivedEmail!.contains("@") ? null : "invalid email";
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter your e-mail"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                obscureText: true,
                onChanged: (receivedPassword) {
                  password = receivedPassword;
                },
                validator: (receivedPassword) {
                  return receivedPassword!.length >= 6
                      ? null
                      : "Password must be at least 6 characters";
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter your password"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 1),
              child: ElevatedButton(
                onPressed: () {
                  addRegister();
                },
                child: registerState ? Text("SIGN IN") : Text("SIGN UP"),
                style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurpleAccent,
                    shadowColor: Colors.black),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      registerState = !registerState;
                    });
                  },
                  child: registerState
                      ? Text(
                          "Register",
                          style: TextStyle(color: Colors.black54),
                        )
                      : Text(
                          "I already have an account ",
                          style: TextStyle(color: Colors.black54),
                        )),
            )
          ],
        ),
      ),
    );
  }

  void addRegister() {
    if (_key.currentState!.validate()) {
      formConnect(username, email, password);
    }
  }

  formConnect(String username, String email, String password) async {
    final Author = FirebaseAuth.instance;
    UserCredential authresult;

    if (registerState) {
      // kayıtlı ise giris yap

      authresult=await Author.signInWithEmailAndPassword(email: email, password: password);

    }
    else
      {
      // kayıt olamdıgı zaman kayıt yap

      authresult = await Author.createUserWithEmailAndPassword(
          email: email, password: password);


      String uidHolder = authresult.user!.uid;

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uidHolder)
          .set({
        "username":username,"email":email
      });
    }
  }
}
