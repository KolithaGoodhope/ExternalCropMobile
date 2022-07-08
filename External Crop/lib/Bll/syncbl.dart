import 'dart:convert';
import 'package:external_crop/Objects/NFCVehicleDetail.dart';
import 'package:external_crop/Objects/entity.dart';
import 'package:external_crop/Objects/entityvehicle.dart';
import 'package:external_crop/Objects/tempVehicle.dart';
import 'package:external_crop/Objects/vehicle.dart';
import 'package:external_crop/Utils/dbhelper.dart';
import 'package:external_crop/Utils/globl.dart';
import 'package:external_crop/Objects/keyvalue.dart';
import 'package:external_crop/Utils/constants.dart';
import 'package:http/http.dart'  as http;

class Syncbl{

  Future getEntityList() async
  {
    try {
      final response = await http
          .get(Uri.parse(Globle.getEntityList(Globle.userUID)));

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        if(response.body !="null") {
          List jsonResponse = json.decode(response.body);
          List<Entity> entityList = jsonResponse.map((job) => new Entity.fromJson(job)).toList();

          if(entityList.length > 0){
            for(int xx= 0;xx<entityList.length;xx++){
              await DBHelper.db.saveEntities(entityList[xx]);
            }
          }
          return 1;
        }
        else{
          List jsonResponse =[];
          return 1;
     //     return jsonResponse;
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        return -1;
      }
    }
    catch(Exception)
    {
      return -1;
    }
  }

  Future getVehicleList() async
  {
    try {
      final response = await http
          .get(Uri.parse(Globle.getVehicleList(Globle.userUID)));

      if (response.statusCode == 200) {
        if(response.body !="null") {
          List jsonResponse = json.decode(response.body);
          List<Vehicle> entityList = jsonResponse.map((job) => new Vehicle.fromJson(job)).toList();

          if(entityList.length > 0){
            for(int xx= 0;xx<entityList.length;xx++){
              await DBHelper.db.saveVehicles(entityList[xx]);
            }
          }
          return 1;
        }
        else{
          List jsonResponse =[];
          return 1;
          //     return jsonResponse;
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        return -1;
      }
    }
    catch(Exception)
    {
      return -1;
    }
  }

  Future getTempVehicleList() async
  {
    try {
      final response = await http
          .get(Uri.parse(Globle.getTempVehicleList(Globle.userUID)));

      if (response.statusCode == 200) {
        if(response.body !="null") {
          List jsonResponse = json.decode(response.body);
          List<TempVehicle> entityList = jsonResponse.map((job) => new TempVehicle.fromJson(job)).toList();

          if(entityList.length > 0){
            for(int xx= 0;xx<entityList.length;xx++){
              await DBHelper.db.saveTempVehicles(entityList[xx]);
            }
          }
          return 1;
        }
        else{
          List jsonResponse =[];
          return 1;
          //     return jsonResponse;
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        return -1;
      }
    }
    catch(Exception)
    {
      return -1;
    }
  }

  Future getEntityVehicleList() async
  {
    try {
      final response = await http
          .get(Uri.parse(Globle.getEntityVehicleList(Globle.userUID)));

      if (response.statusCode == 200) {
        if(response.body !="null") {
          List jsonResponse = json.decode(response.body);
          List<EntityVehicleMap> entityList = jsonResponse.map((job) => new EntityVehicleMap.fromJson(job)).toList();

          if(entityList.length > 0){
            for(int xx= 0;xx<entityList.length;xx++){
              await DBHelper.db.saveEntityVehicleMapping(entityList[xx]);
            }
          }
          return 1;
        }
        else{
          List jsonResponse =[];
          return 1;
          //     return jsonResponse;
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        return -1;
      }
    }
    catch(Exception)
    {
      return -1;
    }
  }

  Future<String> downloadData() async {
    try {
      String retVal ="-1";
      await this.clearMasterTables().then((res) async {
        if(res == "1") {
          await this.getKeyValueList().then((val) async {
            if (val == 1) {
              await this.getEntityList().then((val) async {
                if (val == 1) {
                  await this.getVehicleList().then((resveh) async {
                    if (resveh == 1) {
                      await this.getEntityVehicleList().then((resveh) async {
                        if (resveh == 1) {
                          await this.getTempVehicleList().then((resmap) async {
                            if (resmap == 1) {
                              await DBHelper.db.getKeyValues().then((value) {
                                if (value != "null") {
                                  List keyValueList = value.map((
                                      job) => new KeyValue.fromJson(job))
                                      .toList();
                                  Globle.isRegistrationEnabled = false;
                                  Globle.isECDataEnabled = false;
                                  Globle.isConfirmationEnabled = false;
                                  Globle.isReportEnabled = false;
                                  for (int ii = 0; ii <
                                      keyValueList.length; ii++) {
                                    KeyValue kvalue = keyValueList[ii];
                                    if (int.parse(kvalue.ECM_VAL_KEY) ==
                                        Constants.FUNCTION_KEY) {
                                      Globle.isUserFunctionDataAvailable = true;
                                      if (int.parse(kvalue.ECM_VAL_VALUE_2) ==
                                          Constants.FUNCTION_KEY_REGISTRATION) {
                                        Globle.isRegistrationEnabled = true;
                                      } else
                                      if (int.parse(kvalue.ECM_VAL_VALUE_2) ==
                                          Constants
                                              .FUNCTION_KEY_EXTERNAL_CROP_DATA) {
                                        Globle.isECDataEnabled = true;
                                      } else
                                      if (int.parse(kvalue.ECM_VAL_VALUE_2) ==
                                          Constants.FUNCTION_KEY_CONFIRMATION) {
                                        Globle.isConfirmationEnabled = true;
                                      } else if (int.parse(kvalue
                                          .ECM_VAL_VALUE_2) ==
                                          Constants.FUNCTION_KEY_REPORT) {
                                        Globle.isReportEnabled = true;
                                      }
                                    }
                                  }
                                }
                              });
                              retVal = "1";
                            }
                          });
                        }
                      });
                    }
                  });
                }
              });
            }
          });
        }
      });
        return retVal;
    }
    catch(ex){
      return "-1";
    }
  }

  Future<String> uploadData() async {
    try {
      String retVal ="-1";

      await this.getNFCVehicleList().then((resveh) async {
        if(resveh ==1) {
          await DBHelper.db.clearTransActionTables().then((resmap) async {
              retVal = "1";
          });
        }
      });

      return retVal;
    }
    catch(ex){
      return "-1";
    }
  }

  Future getNFCVehicleList() async
  {
    try {
        List nfcVehicles = await DBHelper.db.getNFCVehicleDetail();
        List<NFCVehicleDetail> nfcVehicleList = nfcVehicles.map((job) => new NFCVehicleDetail.fromJson(job)).toList();
        String jsonNFCVehicleList = jsonEncode(nfcVehicleList);

        final response = await http.get(Uri.parse(Globle.sendNFCVehicleData(jsonNFCVehicleList)));
        if (response.statusCode == 200) {
          if(response.body !="null") {
            if(response.body =="1") {
              return 1;
            }else{
              return -1;
            }
          }
          else{
            return -1;
          }
        } else {
          // If the server did not return a 200 OK response,
          // then throw an exception.
          return -1;
        }
    }
    catch(Exception)
    {
      return -1;
    }
  }

  Future<String> clearMasterTables() async {
    try {
      String retVal ="-1";
      await DBHelper.db.clearTables().then((val) {
        retVal ="1";
      });
      return retVal;
    }
    catch(ex){
      return "-1";
    }
  }

  Future getKeyValueList() async
  {
    try {
      final response = await http
          .get(Uri.parse(Globle.getKeyValueList(Globle.userUID,Globle.userroleID)));

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        if(response.body !="null") {
          List jsonResponse = json.decode(response.body);
          List<KeyValue> keyValueList = jsonResponse.map((job) => new KeyValue.fromJson(job)).toList();

          if(keyValueList.length > 0){
            for(int xx= 0;xx<keyValueList.length;xx++){
              await DBHelper.db.saveKeyValues(keyValueList[xx]);
            }
          }
          return 1;
        }
        else{
          List jsonResponse =[];
          return 1;
          //     return jsonResponse;
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        return -1;
      }
    }
    catch(Exception)
    {
      return -1;
    }
  }

}