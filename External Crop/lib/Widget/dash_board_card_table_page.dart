import 'dart:ui';
import 'package:external_crop/Utils/globl.dart';
import 'package:flutter/material.dart';
import 'package:external_crop/Screens/login_screen.dart';
import 'package:external_crop/Screens/external_crop.dart';
import 'package:external_crop/Screens/sync_screen.dart';
import 'package:external_crop/Screens/external_crop_summary_report.dart';
import 'package:external_crop/Widget/question_dialog.dart';
import 'package:external_crop/Screens/settings_screen.dart';
import 'package:external_crop/Screens/pending_list.dart';
import 'package:external_crop/Screens/registration.dart';
import 'package:external_crop/Utils/constants.dart';

import 'base_alert_dialog.dart';

class CardTablePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Table(
    children: <TableRow>[
      TableRow(
        children: <Widget>[
          _SingleCard(
            ccolor: Colors.black54,
            icon: Icons.add_business_rounded,
            text: 'Registration',
            navigatePage: () {
              return Registration();
              },
            checkValidity: true,
            functionID: Constants.FUNCTION_KEY_REGISTRATION,
          ),
          _SingleCard(
              ccolor: Colors.black54,
              icon: Icons.add_chart,
              text: 'External Crop',
              navigatePage: () {
                return ExternalCrop();
              },
            checkValidity: true,
            functionID: Constants.FUNCTION_KEY_EXTERNAL_CROP_DATA,
          ),
        ],
      ),
      TableRow(
        children: [
          _SingleCard(
            ccolor: Colors.black54,
            icon: Icons.approval,
            text: 'Confirmation',
            navigatePage: () {
              return Pending_ECList();
            },
            checkValidity: true,
            functionID: Constants.FUNCTION_KEY_CONFIRMATION,
          ),
          _SingleCard(
            ccolor: Colors.black54,
            icon: Icons.analytics_outlined,
            text: 'Report',
            navigatePage: () {
              return ExternalCropSummaryReport();
            },
            checkValidity: true,
            functionID: Constants.FUNCTION_KEY_REPORT,
          ),
        ],
      ),
      TableRow(
        children: [
          _SingleCard(
            ccolor: Colors.black54,
            icon: Icons.sync_rounded,
            text: 'Sync',
            navigatePage: () {
              return SyncScreen();
            },
            checkValidity: false,
            functionID: 0,
          ),
          _SingleCard(
            ccolor: Colors.black54,
            icon: Icons.settings,
            text: 'Settings',
            navigatePage: () {
              return SettingsScreen();
            },
            checkValidity: false,
            functionID: 0,
          ),
        ],
      ),
      TableRow(
        children: [
          _SingleCardWithMessage(
            ccolor: Colors.black54,
            icon: Icons.login,
            text: 'Log Out',
          ),
          _nullCardWithMessage(),
        ],
      ),

    ],
  );

}

class _SingleCard extends StatelessWidget {
  final IconData icon;
  final Color ccolor;
  final String text;
  final Widget Function() navigatePage;
  final int functionID;
  final bool checkValidity;

  const _SingleCard({
    this.icon,
    this.ccolor,
    this.text,
    this.navigatePage,
    this.functionID,
    this.checkValidity,
  });

  @override
  Widget build(BuildContext context) => _CardBackground(
      child:InkWell(
      child: Container(
        height: 180,
        decoration: BoxDecoration(
//          color: Constants.lightBrown,//Color.fromRGBO(62, 66, 107, 0.7),
          color:Colors.green,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: this.ccolor,
              child: Icon(this.icon, size: 35, color: Colors.white),
              radius: 30,
            ),
            SizedBox(height: 30),
            Text(
              this.text,
              style: TextStyle(color: this.ccolor, fontSize: 18),
            ),
          ],
        ),
      ),
      onTap: ()
      {
  //      Navigator.of(context).pop();
        if(this.checkValidity == false) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) {
                return this.navigatePage();
              }));
        }else{
          if(Globle.isUserFunctionDataAvailable == false){
            var baseDialog = BaseAlertDialog(
              title: "Alert",
              content: "Please sync before accessing this.",
              yesOnPressed: () {
                Navigator.pop(context);
              },
              yes: "OK",
            );
            showDialog(context: context, builder: (BuildContext context) => baseDialog);
          }
          else if(this.functionID == Constants.FUNCTION_KEY_REGISTRATION){
            if(Globle.isRegistrationEnabled == true) {

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return this.navigatePage();
                  }));

            }else{
              var baseDialog = BaseAlertDialog(
                title: "Alert",
                content: "You do not have permission to access this.",
                yesOnPressed: () {
                  Navigator.pop(context);
                },
                yes: "OK",
              );
              showDialog(context: context, builder: (BuildContext context) => baseDialog);
            }
          }
          else if(this.functionID == Constants.FUNCTION_KEY_EXTERNAL_CROP_DATA){
            if(Globle.isECDataEnabled == true) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return this.navigatePage();
                  }));
            }else{
              var baseDialog = BaseAlertDialog(
                title: "Alert",
                content: "You do not have permission to access this.",
                yesOnPressed: () {
                  Navigator.pop(context);
                },
                yes: "OK",
              );
              showDialog(context: context, builder: (BuildContext context) => baseDialog);
            }
          }
          else if(this.functionID == Constants.FUNCTION_KEY_CONFIRMATION){
            if(Globle.isConfirmationEnabled == true) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return this.navigatePage();
                  }));
            }else{
              var baseDialog = BaseAlertDialog(
                title: "Alert",
                content: "You do not have permission to access this.",
                yesOnPressed: () {
                  Navigator.pop(context);
                },
                yes: "OK",
              );
              showDialog(context: context, builder: (BuildContext context) => baseDialog);
            }
          }
          else if(this.functionID == Constants.FUNCTION_KEY_REPORT){
            if(Globle.isReportEnabled == true) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return this.navigatePage();
                  }));
            }else{
              var baseDialog = BaseAlertDialog(
                title: "Alert",
                content: "You do not have permission to access this.",
                yesOnPressed: () {
                  Navigator.pop(context);
                },
                yes: "OK",
              );
              showDialog(context: context, builder: (BuildContext context) => baseDialog);
            }
          }
        }
      }
    ),
  );
}

class _CardBackground extends StatelessWidget {
  final Widget child;
  const _CardBackground({this.child });

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.all(15),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: this.child,
      ),
    ),
  );
}

class _SingleCardWithMessage extends StatelessWidget {
  final IconData icon;
  final Color ccolor;
  final String text;

  const _SingleCardWithMessage({
    this.icon,
    this.ccolor,
    this.text,
  });

  @override
  Widget build(BuildContext context) => _CardBackground(
    child:InkWell(
        child: Container(
          height: 180,
          decoration: BoxDecoration(
//            color: Constants.lightBrown,//Color.fromRGBO(62, 66, 107, 0.7),
            color: Colors.green,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: this.ccolor,
                child: Icon(this.icon, size: 35, color: Colors.white),
                radius: 30,
              ),
              SizedBox(height: 30),
              Text(
                this.text,
                style: TextStyle(color: this.ccolor, fontSize: 18),
              ),
            ],
          ),
        ),
        onTap: () => _LogoutMessage(context),

    ),
  );

  _LogoutMessage(BuildContext context)
  {
    var baseDialog =
    QuestionDialog(
        title: "Alert",
        content: "Are you sure you want to logout?",
        yesOnPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),    // HomeScreen(),
            ), (route) => false,
          );
        },
        noOnPressed: () {
          Navigator.pop(context);
        },
        yes: "Yes", no: "No"
    );
    showDialog(context: context,
        builder: (BuildContext context) => baseDialog);
  }
}

class _nullCardWithMessage extends StatelessWidget {
  const _nullCardWithMessage();

  @override
  Widget build(BuildContext context) => _CardBackground(
      child: Container(),
  );
}