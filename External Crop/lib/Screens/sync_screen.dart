import 'dart:async';

import 'package:external_crop/Bll/syncbl.dart';
import 'package:external_crop/Utils/globl.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:external_crop/Widget/sync_screen_header.dart';
import 'package:external_crop/Utils/constants.dart';

class SyncScreen extends StatefulWidget {

  const SyncScreen({Key key}) : super(key: key);

  @override
  _SyncScreenState createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {

  double _percentage = 0.0;
  String _percentageValue = "0.0%";
  Color pColor = Constants.green;
  Syncbl _syncbl = Syncbl();
  String _syncLog = "";
  int _timeDuration =1000;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), ()
    {
      _startSync();
      _connectNetwork();
    });

  }


  @override
  Widget build(BuildContext context) {

    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
      body: Stack(
        children: [
          SyncScreenHeader(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: new LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width - 50,
                    animation: true,
                    lineHeight: 40.0,
                    animationDuration: _timeDuration,//2000,
                    percent: _percentage,
                    center: Text(_percentageValue),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: pColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child:   Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                    color: Colors.white54,
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,child: Text(_syncLog,style: TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 12,color: Colors.black)),
                    ),
                  ),
                ),

              ],
            ),
          ),
      ]),
    ),
    );
  }

   void _startSync()
   {
      setState(() {
        _percentage = 0.1;
        _percentageValue = "10.0%";
        _syncLog = _syncLog + "Sync Started.";
        _timeDuration = 1000;
      });
   }

  _connectNetwork()
  {
     Globle _globl = new Globle();
     _globl.isNetworkConnected().then((isConnected){
       setState(() {
         if(isConnected == true) {
           _percentage = 0.2;
           _percentageValue = "20.0%";
           _syncLog = _syncLog + "\n" + "Network Connected.";
           _timeDuration = 0;
           _startDataTransfer();
         }
         else
         {
           _percentage = 0.15;
           _percentageValue = "15.0%";
           pColor = Colors.redAccent;
           _timeDuration = 0;
           _syncLog = _syncLog + "\n" + "Server does not respond.";
         }
       });
     });
   }

  _startDataTransfer()
  {
    Timer(Duration(seconds: 1), () {
      setState(() {
        _syncLog = _syncLog + "\n" + "Data upload started...";
        _percentage = 0.25;
        _percentageValue = "25.0%";
        _timeDuration = 0;
      });
      _dataUpload();
    });
  }

  _dataUpload() {
    _syncbl.uploadData().then((value) {
      if(value == "1") {
          setState(() {
            _syncLog = _syncLog + "\n" + "Data upload Completed...";
            _syncLog = _syncLog + "\n" + "Data download Started...";
            _percentage = 0.6;
            _percentageValue = "60.0%";
            _timeDuration = 0;
          });
          _dataDownLoad();
      }
      else
      {
        setState(() {
          _syncLog = _syncLog + "\n" + "Data upload Failed.";
          _percentage = 0.45;
          _percentageValue = "45.0%";
          pColor = Colors.redAccent;
          _timeDuration = 0;
        });
      }
    });
  }

  _dataDownLoad() {

      _syncbl.downloadData().then((value) {
        if (value == "1") {
          setState(() {
            _syncLog = _syncLog + "\n" + "Data download Completed...";
            _percentage = 0.98;
            _timeDuration = 0;
            _percentageValue = "98.0%";
          });
          _syncCompleted();
        }
        else {
          setState(() {
            _syncLog = _syncLog + "\n" + "Data download failed...";
            _percentage = 0.90;
            pColor = Colors.redAccent;
            _percentageValue = "90.0%";
            _timeDuration = 0;
          });
        }
      });
  }

    _syncCompleted()
    {
      Timer(Duration(seconds: 1), () {
        setState(() {
          _syncLog = _syncLog + "\n" + "Sync Completed...";
          _percentage = 1.0;
          _percentageValue = "100.0%";
        });
      });

    }
}
