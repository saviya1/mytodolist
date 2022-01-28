import 'dart:html';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:collection';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        accentColor: Colors.orange),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List todos = [];
  String input = "";
  final FirebaseFirestore db = FirebaseFirestore.instance;

  createTodos() {
    final _collectionReference =
        db.collection("MesTaches").doc(input).collection("Profil");
    // final _DocumentReference = _collectionReference.doc("ijihihd");
    final _DocumentReference = _collectionReference.doc('ProfiInfo');

    //Map
    Map<String, String> todos = {"TitreTach": input};

    _DocumentReference.set(todos).whenComplete(() {
      print("$input created");
    });
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("mestaches"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Add Todolist"),
                    content: TextField(
                      onChanged: (String value) {
                        input = value;
                      },
                    ),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            createTodos();
                            Navigator.of(context).pop();
                          },
                          child: Text("Add"))
                    ],
                  );
                });
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: StreamBuilder(
            stream: db.collection("MesTaches").snapshots(),
            //  stream: db
            //         .collection("MesTaches")
            //         .doc(input)
            //         .collection("Profil")
            //         .snapshots(),
            builder: (context, snapshots) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshots.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        snapshots.data.documents[index];
                    return Dismissible(
                      key: Key(index.toString()),
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                          title: Text(documentSnapshot["todoTitle"]),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                todos.removeAt(index);
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  });
            }));
  }
}
