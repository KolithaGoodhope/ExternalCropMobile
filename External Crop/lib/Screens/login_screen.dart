import 'dart:io';
import 'dart:math';
import 'package:external_crop/Widget/customClipper.dart';
import 'package:flutter/material.dart';
import 'package:external_crop/Screens/home_screen.dart';
import 'package:external_crop/Bll/loginbl.dart';
import 'package:external_crop/Utils/globl.dart';
import 'package:external_crop/Objects/user.dart';
import 'package:external_crop/Widget/base_alert_dialog.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:device_info/device_info.dart';
import 'package:external_crop/Utils/constants.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final userNameController = TextEditingController();
  final passWordController = TextEditingController();
  LoginBl loginBl = LoginBl();
  bool _databaseIsCreated = false;
  String _deviceID;
  Globle _globle = Globle();

  @override
  void initState() {
    _checkDBAlreadyCreated();
    _getId().then((id) {
      _deviceID = id;
    });
    loginBl.getRegisteredUserID().then((uName){
      userNameController.text = uName;
    });
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    userNameController.dispose();
    passWordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final boxDecoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.2, 0.8],
        colors: [
          Colors.green.shade100,//Color(0xff9295EF),
          Colors.green.shade200//Color(0xff202333),
        ],
      ),
    );

    return Scaffold(
        body: Container(
          height: height,
          child: Stack(
            children: <Widget>[

              Container(decoration: boxDecoration),

              Positioned(
                top: -MediaQuery.of(context).size.height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: Container(
                    child: Transform.rotate(
                      angle: -pi / 3.5,
                      child: ClipPath(
                        clipper: ClipPainter(),
                        child: Container(
                          height: MediaQuery.of(context).size.height * .5,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.green.shade200,//Color(0xff2E305F),      //0xffE6E6E6
                                Colors.green.shade300//Color(0xff202333),
                              ],

                            ),
                          ),
                        ),
                      ),
                    )),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * 0.2),
                      SizedBox
                        (
                        width: 175,
                        height: 150,
                        child: Image.asset(
                          "assets/login_logo_new.png",
                          fit: BoxFit.fill,
                        ),
                      ),

                      SizedBox(height: 50),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Username",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15,color: Colors.black54),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                    obscureText: false,
                                    controller: userNameController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true))
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Password",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15,color: Colors.black54),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                    obscureText: true,
                                    controller: passWordController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true))
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => _onPressLogin(userNameController.text.trim(),passWordController.text.trim()),

                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey.shade700,
                                  offset: Offset(2, 4),
                                  blurRadius: 5,
                                  spreadRadius: 2)
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.green,  //0xff14279B
                                Colors.green//Color(0xff14279B),
                              ],
                            ),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(fontSize: 20, color: Colors.black54),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                          "Version:"+_globle.version,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 7,color: Colors.black54),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void _onPressLogin(String userName,String password) async
  {
    if (userName == "" || password == "") {
      var baseDialog = BaseAlertDialog(
        title: "Alert",
        content: "UserName & Password cannot be empty.",
        yesOnPressed: () {
          Navigator.pop(context);
        },
        yes: "OK",
      );
      showDialog(context: context,
          builder: (BuildContext context) => baseDialog);

    }
    else {
      EasyLoading.show();

      bool _isnewtworkConnected = await _globle.isNetworkConnected() as bool;
      String passwordEnc = md5.convert(utf8.encode(passWordController.text))
          .toString();

      if (_databaseIsCreated) {
        User user = await _globle.getCurrentUser();
        if (user != null) {
          await loginBl.getUserControlData();
          if (loginBl.validateUserByUnamePassword(
              userNameController.text.trim(), passwordEnc, user)) {
            EasyLoading.dismiss();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(), // HomeScreen(),
              ),
            );
          }
          else {
            EasyLoading.dismiss();
            var baseDialog = BaseAlertDialog(
              title: "Alert",
              content: "User name or Password incorrect.",
              yesOnPressed: () {
                Navigator.pop(context);
              },
              yes: "OK",
            );
            showDialog(context: context,
                builder: (BuildContext context) => baseDialog);
          }
        }
        else if (_isnewtworkConnected) {
          int userResponseID = await loginBl.checkUserByServer(
            userNameController.text.trim(), passwordEnc, _deviceID) as int;
          if (userResponseID > 0) {
            await loginBl.getUserDetailsByUserNamePassword(
                userNameController.text.trim(), passwordEnc);
            EasyLoading.dismiss();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(), // HomeScreen(),
              ),
            );
          }
          else {
            String errorMessage = "";
            switch (userResponseID) {
              case -500:
                errorMessage = "Error occurred.";
                break;
              case -400:
                errorMessage = "Invalid userName.";
                break;
              case -200:
                errorMessage = "server not responding.";
                break;
              case -1:
                errorMessage = "Login authentication failed.";
                break;
              case -2:
                errorMessage =
                "Login already has an active site for a different device.";
                break;
              case -3:
                errorMessage = "Server side login disabled.";
                break;
            }

            EasyLoading.dismiss();
            var baseDialog = BaseAlertDialog(
              title: "Alert",
              content: errorMessage,
              yesOnPressed: () {
                Navigator.pop(context);
              },
              yes: "OK",
            );
            showDialog(context: context,
                builder: (BuildContext context) => baseDialog);
          }
        }
        else {
          EasyLoading.dismiss();
          var baseDialog = BaseAlertDialog(
            title: "Alert",
            content: "Error occurred. Please contact administrator. ",
            yesOnPressed: () {
              Navigator.pop(context);
            },
            yes: "OK",
          );
          showDialog(context: context,
              builder: (BuildContext context) => baseDialog);
        }
      }
      else if (_isnewtworkConnected) {
        int userResponseID = await loginBl.checkUserByServer(
            userNameController.text.trim(), passwordEnc, _deviceID) as int;
        if (userResponseID > 0) {
          await loginBl.getUserDetailsByUserNamePassword(
             userNameController.text.trim(), passwordEnc);
          loginBl.createDatabaseTables();
          EasyLoading.dismiss();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(), // HomeScreen(),
            ),
          );
        }
        else {
          String errorMessage = "";
          switch (userResponseID) {
            case -500:
              errorMessage = "Error occurred.";
              break;
            case -400:
              errorMessage = "Invalid userName.";
              break;
            case -200:
              errorMessage = "server not responding.";
              break;
            case -1:
              errorMessage = "Login authentication failed.";
              break;
            case -2:
              errorMessage =
              "Login already has an active site for a different device.";
              break;
            case -3:
              errorMessage = "Server side login disabled.";
              break;
          }

          EasyLoading.dismiss();
          var baseDialog = BaseAlertDialog(
            title: "Alert",
            content: errorMessage,
            yesOnPressed: () {
              Navigator.pop(context);
            },
            yes: "OK",
          );
          showDialog(context: context,
              builder: (BuildContext context) => baseDialog);
        }
      }
      else {
        EasyLoading.dismiss();
        var baseDialog = BaseAlertDialog(
          title: "Alert",
          content: "No Internet Connection.",
          yesOnPressed: () {
            Navigator.pop(context);
          },
          yes: "OK",
        );
        showDialog(context: context,
            builder: (BuildContext context) => baseDialog);
      }
    }
  }

  void _checkDBAlreadyCreated() async
  {
    var _alreadyDBCreated = await loginBl.getDatabaseAlreadyExists();
    _databaseIsCreated = _alreadyDBCreated as bool ;

  }

  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

}