import 'Screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
//        textTheme:GoogleFonts.latoTextTheme(textTheme).copyWith(
//          bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
//        ),
        ),
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
        builder: EasyLoading.init()
    );
  }
}