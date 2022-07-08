import 'dart:convert';
import 'package:external_crop/Objects/location.dart';
import 'package:external_crop/Utils/globl.dart';
import 'package:http/http.dart'  as http;
import 'package:external_crop/Objects/mill.dart';
import 'package:external_crop/Objects/ecreportitem.dart';

class ExternalCropSummaryReportBL{

  Future getAssignedMills() async
  {
    try {
      final response = await http
          .get(Uri.parse(Globle.getLocation(Globle.userUID, 1)));

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        if(response.body !="null") {
          List jsonResponse = json.decode(response.body);
          return jsonResponse.map((job) => new Mill.fromJson(job)).toList();
        }
        else{
          List jsonResponse =[];
          return jsonResponse;
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        return null;
      }
    }
    catch(Exception)
    {
      return null;
    }
  }

  Future getReportData(DateTime month,int locationUID) async
  {
    try {
      final response = await http
          .get(Uri.parse(
          Globle.getECReportData(Globle.userUID, locationUID, month)));

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        if(response.body != "null") {
          List jsonResponse = json.decode(response.body);
          return jsonResponse.map((job) => new ECReportItem.fromJson(job))
              .toList();
        }else{
          List jsonResponse =[];
          return jsonResponse;
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        return null;
      }
    }
    catch(exception){
      return null;
    }
  }

}