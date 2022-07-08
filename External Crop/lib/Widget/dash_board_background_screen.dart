import 'dart:math';
import 'package:flutter/material.dart';
import 'package:external_crop/Utils/constants.dart';

class BackgroundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final boxDecoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.2, 0.8],
        colors: [
//          Constants.darkOrange,//Color(0xff2E305F),
//          Constants.darkOrange//Color(0xff202333),
          Colors.green.shade200,Colors.green.shade200
        ],
      ),
    );
    return Stack(
      children: [
        // color morado
        Container(decoration: boxDecoration),

        // Pink Box
        Positioned(
          top: -100,
          left: -40,
          child: _PinkBox(),
        ),
      ],
    );
  }
}

class _PinkBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -pi / 5,
      child: Container(
        height: 360,
        width: 360,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80),
          gradient: LinearGradient(
            colors: [
//              Constants.lightOrange,//Color.fromRGBO(10, 56, 191, 1),
//              Constants.lightOrange//Color.fromRGBO(7, 25, 172, 1),
              Colors.green.shade300,Colors.green.shade300
            ],
          ),
        ),
      ),
    );
  }
}