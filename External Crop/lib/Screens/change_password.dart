import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:external_crop/Bll/changepasswordbl.dart';
import 'package:external_crop/Utils/globl.dart';
import 'package:external_crop/Widget/base_alert_dialog.dart';
import 'package:external_crop/Widget/chagepasswordheader.dart';
import 'package:flutter/material.dart';


class ChangePassword extends StatefulWidget {
  @override
  _ChangePassword createState() => _ChangePassword();
}

class _ChangePassword extends State<ChangePassword> {

  final _currentPassWordController = TextEditingController();
  final _newpassWordController = TextEditingController();
  final _reenterNewPassWordController = TextEditingController();
  ChangePasswordBL _changePasswordBL = new ChangePasswordBL();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        body: Stack(
          children: [
            ChagePasswordHeader(),
            FormUI(context),
          ],
        ),
      ),
    );
  }

  Widget FormUI(BuildContext context) {
    double pageheight = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double totalverPad = statusBarHeight + (pageheight * 0.15) ;

    return SafeArea(
      child :Container(
        child:Padding(
          padding: EdgeInsets.fromLTRB(10.0, totalverPad, 10.0, 10.0),
          child: ListView(
              children: <Widget>[
                Material(
                  shadowColor: Colors.white.withOpacity(0.01), // added
                  type: MaterialType.card,
                  elevation: 10,
                  borderRadius: new BorderRadius.circular(10.0),

                  child: Column(
                      children: [
                        Container(margin: EdgeInsets.all(5),
                          color: Colors.white,

                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Current Password",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15,color: Colors.black54),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                  obscureText: true,
                                  controller: _currentPassWordController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true)),
                              SizedBox(height:10),
                              Text(
                                "New Password",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15,color: Colors.black54),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                  obscureText: true,
                                  controller: _newpassWordController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true)),
                              SizedBox(height:10),
                              Text(
                                "Re-enter New Password",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15,color: Colors.black54),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                  obscureText: true,
                                  controller: _reenterNewPassWordController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true)),
                              SizedBox(height:10),
                              Container(margin: EdgeInsets.all(10),
                                color: Colors.white,
                                child: Table(
                                  border: TableBorder.symmetric(inside: BorderSide(color: Colors.white70) ),columnWidths: {
                                  0: FixedColumnWidth(MediaQuery.of(context).size.width*0.4),
                                  1: FlexColumnWidth(MediaQuery.of(context).size.width*0.1),
                                  2: FlexColumnWidth(MediaQuery.of(context).size.width*0.4),
                                },
                                  children: [
                                    TableRow(
                                        children: [
                                          SizedBox(
                                              child : ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                                          (Set<MaterialState> states) {
                                                        //return Color(0xffe6963e);
                                                            return Colors.green;
                                                      }),
                                                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                                                          (Set<MaterialState> states) {
                                                        return Colors.white;
                                                      }),
                                                ),
                                                onPressed: () {
                                                  _changePassword();
                                                },
                                                child: Text('Change'),
                                              )
                                          ),

                                          SizedBox(width: 5),
                                          //                    SizedBox(
                                          SizedBox(
                                              child : ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                                          (Set<MaterialState> states) {
                                                        //return Color(0xffe6963e);
                                                            return Colors.green;
                                                      }),
                                                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                                                          (Set<MaterialState> states) {
                                                        return Colors.white;
                                                      }),
                                                ),
                                                onPressed: _clearAll,
                                                child: Text('Clear'),
                                              )
                                          ),
                                        ]),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ]),
                ),
              ]),
        ),
      ),

    );
  }

  _changePassword(){

    if(_newpassWordController.text.trim() =="" || _reenterNewPassWordController.text.trim() =="" || _currentPassWordController.text.trim() ==""){
      var baseDialog = BaseAlertDialog(
      title: "Alert",
      content: "All fields are required.",
      yesOnPressed: () {Navigator.pop(context);},
      yes: "OK",
      );
      showDialog(context: context, builder: (BuildContext context) => baseDialog);
    }
    else if(_newpassWordController.text.length<3){
      var baseDialog = BaseAlertDialog(
        title: "Alert",
        content: "Password length must be greater than 3.",
        yesOnPressed: () {Navigator.pop(context);},
        yes: "OK",
      );
      showDialog(context: context, builder: (BuildContext context) => baseDialog);
    }
    else if(_newpassWordController.text != _reenterNewPassWordController.text)
    {
      var baseDialog = BaseAlertDialog(
        title: "Alert",
        content: "The new password does not match the  password entered again.",
        yesOnPressed: () {Navigator.pop(context);},
        yes: "OK",
      );
      showDialog(context: context, builder: (BuildContext context) => baseDialog);
    }
    else
    {
      String _currentPassWord = md5.convert(utf8.encode(_currentPassWordController.text.trim())).toString();
      String _newpassWord = md5.convert(utf8.encode(_newpassWordController.text.trim())).toString();

      _changePasswordBL.changeExsistingPassword(_currentPassWord, _newpassWord).then((value) {
        if(value == null){
          var baseDialog = BaseAlertDialog(
            title: "Alert",
            content: "Unexpected error occurred. Please try again.",
            yesOnPressed: () {Navigator.pop(context);},
            yes: "OK",
          );
          showDialog(context: context, builder: (BuildContext context) => baseDialog);
        }
        else if(value == "-1"){
          var baseDialog = BaseAlertDialog(
            title: "Alert",
            content: "Existing password is incorrect.",
            yesOnPressed: () {Navigator.pop(context);},
            yes: "OK",
          );
          showDialog(context: context, builder: (BuildContext context) => baseDialog);
        }
        else if(value == "1"){
          _updateDatabase();
        }
        else{
          var baseDialog = BaseAlertDialog(
            title: "Alert",
            content: "Unexpected error occurred. Please try again.",
            yesOnPressed: () {Navigator.pop(context);},
            yes: "OK",
          );
          showDialog(context: context, builder: (BuildContext context) => baseDialog);
        }
      });
    }
  }

  _updateDatabase(){
    String _newpassWord = md5.convert(utf8.encode(_newpassWordController.text.trim())).toString();
    _changePasswordBL.updatePasswordByUser(Globle.userUID, _newpassWord).then((value)
    {
      if(value == 1)
      {
        setState(() {
          _currentPassWordController.text ="";
          _reenterNewPassWordController.text ="";
          _newpassWordController.text ="";
        });

        var baseDialog = BaseAlertDialog(
          title: "Alert",
          content: "Password updated successfully.",
          yesOnPressed: () {
            _clearAll();
            Navigator.pop(context);
            },
          yes: "OK",
        );
        showDialog(context: context, builder: (BuildContext context) => baseDialog);
      }
      else
      {
        var baseDialog = BaseAlertDialog(
          title: "Alert",
          content: "Error Occurred. Please try again.",
          yesOnPressed: () {Navigator.pop(context);},
          yes: "OK",
        );
        showDialog(context: context, builder: (BuildContext context) => baseDialog);
      }
    });
  }

  _clearAll(){
    setState(() {
      _currentPassWordController.text="";
      _newpassWordController.text ="";
      _reenterNewPassWordController.text ="";
    });
  }
}


