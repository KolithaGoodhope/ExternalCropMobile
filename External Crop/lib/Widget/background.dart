import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Container(
                //   alignment: Alignment.topLeft,
                //   child: Stack(
                //     children: [
                //       Container(
                //         width: MediaQuery.of(context).size.width*0.35,
                //         height: MediaQuery.of(context).size.height*0.35,
                //         decoration: BoxDecoration(
                //             color: Colors.blue[300],
                //             borderRadius: BorderRadius.only(topRight: Radius.circular(MediaQuery.of(context).size.width),bottomRight: Radius.circular(MediaQuery.of(context).size.width))
                //         ),
                //       ),
                //       Container(
                //         width: MediaQuery.of(context).size.width*0.75,
                //         height: MediaQuery.of(context).size.height*0.2,
                //         decoration: BoxDecoration(
                //             color: Colors.blue[400],
                //             borderRadius: BorderRadius.only(bottomLeft: Radius.circular(MediaQuery.of(context).size.width),bottomRight: Radius.circular(MediaQuery.of(context).size.width))
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Container(
                  alignment: Alignment.bottomRight,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width*0.35,
                        height: MediaQuery.of(context).size.height*0.35,
                        decoration: BoxDecoration(
                            color: Colors.lightGreen[300],
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(MediaQuery.of(context).size.width),bottomLeft: Radius.circular(MediaQuery.of(context).size.width))
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width*0.75,
                        height: MediaQuery.of(context).size.height*0.2,
                        decoration: BoxDecoration(
                            color: Colors.lightGreen[400],
                            borderRadius: BorderRadius.only(topRight: Radius.circular(MediaQuery.of(context).size.width),topLeft: Radius.circular(MediaQuery.of(context).size.width))
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/3,
                  height: MediaQuery.of(context).size.height/1.8,
                  child: Image.asset(
                    "assets/palm_tree2.png",
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width/2.5,
                  height: MediaQuery.of(context).size.height/3,
                  child: Image.asset(
                    "assets/palm_tree1.png",
                    fit: BoxFit.fill,
                  ),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for(int i = 1; i < MediaQuery.of(context).size.width/100;i++) Container(
                    width: 100,
                    height: 100,
                    child: Image.asset(
                      "assets/grass_one.png",
                      fit: BoxFit.fill,
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
