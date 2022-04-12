import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smallproject/screen/display.dart';
import 'package:smallproject/screen/formscreen.dart';

import 'home.dart';
 final auth = FirebaseAuth.instance;
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: TabBarView(
            children: [
              DisplayScreen(),  
              FormScreen()
            ],
            ),
            backgroundColor: Colors.grey,
            bottomNavigationBar: TabBar(
              tabs: [
                Tab(text: "Your Friends",),
                Tab(text: "Add Friends",)
                
              ],
              ),
        ),
        );
  }
}

