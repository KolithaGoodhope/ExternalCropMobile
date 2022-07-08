import 'dart:async';

import 'package:external_crop/Helpers/screenNavigation.dart';
import 'package:external_crop/Screens/login_screen.dart';
import 'package:external_crop/Widget/background.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Timer(
        Duration(seconds: 3),()=> changeScreenReplacement(context, LoginScreen())
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.bottomLeft,
            child: Container(
              width: 180,
              height: 110,
              child: Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25,bottom: 25),
                  child: Container(
                    width: 70,
                    height: 50,
                    child: Image.asset(
                      "assets/goodhope_logo.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/2,
                alignment: Alignment.center,
                child: Text("EC\nManagement",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Colors.green.shade900,shadows: [Shadow(
                  offset: Offset(1.5, 0),
                  blurRadius: 6,
                  color: Colors.white70,
                )]),),
              ),
              CircularProgressIndicator(backgroundColor: Colors.green.shade300,valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade900)),
            ],
          )
        ],
      ),
    );
  }
}

