import 'package:flutter/material.dart';
import 'package:external_crop/Utils/constants.dart';
import 'package:external_crop/Widget/my_custom_clipper.dart';

class ExternalCropHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    double statusBarHeight = MediaQuery.of(context).padding.top;
    double pageHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.green.shade300,
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: MyCustomClipper(clipType: ClipType.bottom),
            child: Container(
            color: Colors.green.shade200,
            height: pageHeight * 0.2 + statusBarHeight,
            ),
          ),

          Positioned(
            right: -45,
            top: -30,
            child: ClipOval(
              child: Container(
                color: Colors.black.withOpacity(0.05),
                height: 220,
                width: 220,
              ),
            ),
          ),

          // BODY
          Padding(
            padding: EdgeInsets.all(Constants.paddingSide),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        // Back Button
                        SizedBox(
                          width: 34,
                          child:RawMaterialButton(
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                                Icons.arrow_back_ios,
                                size: 15.0,
                                color: Colors.black54,//Colors.white
                            ),
                            shape: CircleBorder(
                              side: BorderSide(
                                  color: Colors.black54,//Colors.white,
                                  width: 2,
                                  style: BorderStyle.solid
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text("External Crop",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black54,//Colors.white
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Image(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/external_crop.png'),
                        height: 40,
                        width: 40,
                        color: Colors.black54,//Colors.white.withOpacity(1)
                    ),

                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}








