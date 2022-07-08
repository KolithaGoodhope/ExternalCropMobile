import 'package:flutter/material.dart';
import 'package:external_crop/Utils/constants.dart';
import 'package:external_crop/Widget/my_custom_clipper.dart';

class SyncScreenHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    double statusBarHeight = MediaQuery.of(context).padding.top;
    double pageHeight = MediaQuery.of(context).size.height;
    double pageWeight = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.green.shade300,
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: MyCustomClipper(clipType: ClipType.bottom),
            child: Container(
              color: Colors.green.shade200,//Constants.darkAccent,
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
                                color: Colors.black54
                            ),
                            shape: CircleBorder(
                              side: BorderSide(
                                  color: Colors.black54,
                                  width: 2,
                                  style: BorderStyle.solid
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: pageWeight * 0.1),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: pageWeight * 0.6,
                              child:Text("Sync",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black54,
                                ),

                              ),
                            ),
                            //                       SizedBox(width: pageWeight * 0.1),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Image(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/sync_header.png'),
                        height: 40,
                        width: 40,
                        color: Colors.black54
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








