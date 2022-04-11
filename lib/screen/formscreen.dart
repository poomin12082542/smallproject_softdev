import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smallproject/model/friend.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'home.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}
final auth = FirebaseAuth.instance;
class _FormScreenState extends State<FormScreen> {
  final formKey = GlobalKey<FormState>();
  Friend myFriend = Friend(email: '', fname: '', nname: '', tel: '');
  //เตรียม firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final CollectionReference _friendCollection = FirebaseFirestore.instance.collection("friends");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: Text("ADD FRIENDS"), actions: [
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
      ]
              ),
              body: Container(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nickname",
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          validator: RequiredValidator(
                              errorText: "Required Nickname"),
                          onSaved: (String? nname) {
                            myFriend.nname = nname!;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Fullname",
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          validator: RequiredValidator(
                              errorText: "Required Fullname"),
                          onSaved: (String? lname) {
                            myFriend.fname = lname!;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Email",
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          validator: MultiValidator([
                            EmailValidator(errorText: "Wrong Required Format"),
                            RequiredValidator(
                                errorText: "Required Email")
                          ]),
                          onSaved: (String? email) {
                            myFriend.email = email!;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Phone Number",
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          validator: RequiredValidator(
                              errorText: "Required Phone Number"),
                          onSaved: (String? tel) {
                            myFriend.tel = tel!;
                          },
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              child: Text(
                                "save",
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () async{
                                if (formKey.currentState!.validate()) {
                                   formKey.currentState!.save();
                                   await _friendCollection.add({
                                      "nname":myFriend.nname,
                                      "fname":myFriend.fname,
                                      "email":myFriend.email,
                                      "tel":myFriend.tel
                                   });
                                   formKey.currentState!.reset();
                                }
                              }),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
