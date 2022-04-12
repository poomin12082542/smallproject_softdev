import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'homepage.dart';

class DisplayScreen extends StatefulWidget {
  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

final auth = FirebaseAuth.instance;

class _DisplayScreenState extends State<DisplayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("YOUR FRIENDS"), actions: [
        IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return HomeScreen();
                }));
              });
            })
      ]),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("friends").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: snapshot.data!.docs.map((document) {
                return Container(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: FittedBox(
                        child: Text(document["nname"]),
                      ),
                    ),
                    title: Text(document["fname"]),
                    subtitle: Text("email:" +
                        document["email"] +
                        "  " +
                        "tel:" +
                        document["tel"]),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              scrollable: true,
                              title: Text('Delete friend'),
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Form(
                                  child: Row(
                                    children: <Widget>[
                                      RaisedButton(
                                          child: Text("Yes"),
                                          onPressed: () {

                                            Navigator.pushReplacement(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return MyHomePage(title: '',);
                                            }));
                                          }),
                                      RaisedButton(
                                          child: Text("No"),
                                          onPressed: () {
                                            Navigator.pushReplacement(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return MyHomePage(title: '',);
                                            }));
                                          })
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}

class FireBaseFirestore {
  static var instance;
}
