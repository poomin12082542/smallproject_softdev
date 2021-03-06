import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:smallproject/model/profile.dart';

import 'home.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile(email: '', password: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return Scaffold(
                appBar: AppBar(
                  title: Text("Error"),
                  ),
                body: Center(child: Text("${snapshot.error}"),
                ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: Text("SIGN IN"),actions: [
        IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
                Navigator.pop(context);
            })
      ]),
              body: Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("EMAIL", style: TextStyle(fontSize: 16)),
                          TextFormField(
                            validator: MultiValidator([
                              RequiredValidator(errorText: "Required email"),
                              EmailValidator(errorText: "Wrong email format")
                            ]),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (String? email) {
                              profile.email = email!;
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text("PASSWORD", style: TextStyle(fontSize: 16)),
                          TextFormField(
                            validator: RequiredValidator(errorText: "Required password"),
                              obscureText: true,
                              onSaved: (String? password) {
                              profile.password = password!;
                            },
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text("sign in",style: TextStyle(fontSize: 16)),
                              onPressed: () async{
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState?.save();
                                  try{
                                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                      email: profile.email, 
                                      password: profile.password
                                    ).then((value){
                                      formKey.currentState?.reset();
                                      Fluttertoast.showToast(
                                        msg: "Sign in completed",
                                        gravity: ToastGravity.TOP
                                      );
                                      Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context){
                                          return HomeScreen();
                                      }));
                                    });
                                  }on FirebaseAuthException catch(e){
                                      print(e.code);
                                      String message;
                                      if(e.code == 'email-already-in-use'){
                                          message = "???????????????????????????????????????????????????????????????????????? ?????????????????????????????????????????????????????????";
                                      }else if(e.code == 'weak-password'){
                                          message = "??????????????????????????????????????????????????????????????? 6 ??????????????????????????????????????????";
                                      }else{
                                          message = e.message!;
                                      }
                                      Fluttertoast.showToast(
                                        msg: message,
                                        gravity: ToastGravity.CENTER
                                      );
                                  }
                                }
                              },
                            ),
                          )
                        ],
                      ),
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
