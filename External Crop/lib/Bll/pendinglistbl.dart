import 'dart:convert';
import 'package:external_crop/Objects/locationheader.dart';
import 'package:external_crop/Objects/ecmilldetail.dart';
import 'package:external_crop/Utils/globl.dart';
import 'package:http/http.dart'  as http;

class PendingListBL{


  Future getPendingExternalCropHeader() async
  {
    try {
      final response = await http
          .get(Uri.parse(Globle.getPendingExternalCropHeader(Globle.userUID)));

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        if(response.body !="null") {
          List jsonResponse = json.decode(response.body);
          return jsonResponse.map((job) => new LocationHeader.fromJson(job))
              .toList();
        }else{
          List<LocationHeader>  jsonResponse =[];
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

  Future getExternalCropDetailsByHeaderID(int headerID) async
  {
    try {
      final response = await http
          .get(Uri.parse(Globle.getExternalCropDetailsByHeaderID(headerID)));

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        if(response.body !="null"){
          List jsonResponse = json.decode(response.body);
          return jsonResponse.map((job) => new ECMillDetail.fromJson(job)).toList();
        }
        else{
          List jsonResponse = [];
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

  Future approveECheader(int headerID) async
  {
    try {
      final response = await http
          .get(Uri.parse(Globle.updateECVerification(Globle.userUID,1,headerID)));

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        String responseVal = response.body.toString();
        return responseVal;
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

  Future rejectECheader(int headerID) async
  {
    try {
      final response = await http
          .get(Uri.parse(Globle.updateECVerification(Globle.userUID,0,headerID)));

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        String responseVal = response.body.toString();
        return responseVal;
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