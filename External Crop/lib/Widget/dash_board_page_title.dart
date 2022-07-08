import 'package:external_crop/Utils/globl.dart';
import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('EC Management System',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,//Colors.white,
                )),
            SizedBox(height: 5),
            Text('Welcome '+Globle.userName,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,//Colors.white,
                )),
          ],
        ),
      ),
    );
  }
}