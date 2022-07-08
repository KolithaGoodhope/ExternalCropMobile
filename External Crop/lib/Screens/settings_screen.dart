import 'dart:async';
import 'dart:io';
import 'package:external_crop/Screens/change_password.dart';
import 'package:external_crop/Utils/globl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:external_crop/Widget/settings_screen_header.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:external_crop/Widget/base_alert_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsScreen extends StatefulWidget {

  const SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  Globle globle = Globle();

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
              SettingsScreenHeader(),
              FormListUI(context),
              ]),
    ),
    );
  }

  Widget FormListUI(BuildContext context)
  {

    double pageheight = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double totalverPad = statusBarHeight + (pageheight * 0.15) ;

    return SafeArea(
      child :Container(
        child:Padding(
          padding: EdgeInsets.fromLTRB(10.0, totalverPad, 10.0, 10.0),
            child: ListView(
              children: <Widget>[
                Visibility(
                  visible: true,
                  child: Material(
                    shadowColor: Colors.white.withOpacity(0.01), // added

                    type: MaterialType.card,
                    elevation: 10, borderRadius: new BorderRadius.circular(10.0),

                    child: Column(
                        children: [
                          Container(margin: EdgeInsets.all(10),
                            color: Colors.white,
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(width: MediaQuery.of(context).size.width * 0.8,
                                    child : ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                              // return Color(0xffe6963e);
                                                  return Colors.green;
                                            }),
                                        foregroundColor: MaterialStateProperty.resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                              return Colors.white;
                                            }),
                                      ),
                                      onPressed: (){
                                        _backupAllDatabase();
                                      },
                                      child: Text('Backup Database'),
                                    )
                                ),
                                SizedBox(height: 10),
                                SizedBox(width: MediaQuery.of(context).size.width * 0.8,
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
                                      onPressed: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChangePassword(), // HomeScreen(),
                                          ),
                                        );
                                      },
                                      child: Text('Change Password'),
                                    )
                                ),
                                SizedBox(height: 10),
                              ],
                            ),

                          ),
                        ]),
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }

  _backupAllDatabase() async {
    try {
      EasyLoading.show();
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      final dbFolder = documentsDirectory.path;

      File source1 = File('$dbFolder/External_Crop.db');

      Directory copyTo = Directory("storage/emulated/0/EC_DB_Backup");
      if ((await copyTo.exists())) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        }
      }
      else {
        EasyLoading.dismiss();
        if (await Permission.storage
            .request()
            .isGranted) {
          // Either the permission was already granted before or the user just granted it.
          await copyTo.create();
        }
        else {
          var baseDialog = BaseAlertDialog(
            title: "Alert",
            content: "Please give permission.",
            yesOnPressed: () {
              Navigator.pop(context);
            },
            yes: "OK",
          );
          showDialog(
              context: context, builder: (BuildContext context) => baseDialog);
        }
      }

      String newPath = "${copyTo.path}/External_Crop.db";
      await source1.copy(newPath);
      EasyLoading.dismiss();
      var baseDialog = BaseAlertDialog(
        title: "Alert",
        content: "Process Completed successfully.",
        yesOnPressed: () {
          Navigator.pop(context);
        },
        yes: "OK",
      );
      showDialog(
          context: context, builder: (BuildContext context) => baseDialog);
    }
    catch(ex)
    {
      EasyLoading.dismiss();
      var baseDialog = BaseAlertDialog(
        title: "Alert",
        content: "Error occurred.",
        yesOnPressed: () {Navigator.pop(context);},
        yes: "OK",
      );
      showDialog(context: context, builder: (BuildContext context) => baseDialog);
    }

  }
}
