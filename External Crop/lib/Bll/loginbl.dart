import 'dart:convert';
import 'package:external_crop/Objects/keyvalue.dart';
import 'package:external_crop/Utils/constants.dart';
import 'package:external_crop/Utils/globl.dart';
import 'package:http/http.dart'  as http;
import 'package:external_crop/Utils/dbhelper.dart';
import 'package:external_crop/Objects/user.dart';
//import 'package:convert/convert.dart';
//import 'package:crypto/crypto.dart';

class LoginBl{

  Future<bool> getDatabaseAlreadyExists() async
  {
    var isExists = await DBHelper.db.checkUserByUserNameAndPassword();
    return isExists;
  }

  Future checkUserByServer(String userName,String password,String deviceID) async {

    try {
      final response = await http
          .get(Uri.parse(Globle.getLoginURL(userName, password, deviceID)));

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return int.parse(response.body.trim());
      }
      else {
        return -500;
      }
    }
    catch(ex)
    {
      return -500;
    }
  }

  bool validateUserByUnamePassword(String uname,String password, User user)  {
    if(uname.trim().toUpperCase() == user.USR_USER_NAME.trim().toUpperCase() &&
        password.trim() == user.USR_PASSWORD.trim())
    {
          Globle.userUID = user.USR_ID;
          Globle.userName = user.USR_USER_NAME;
          Globle.userroleID = user.USER_ROLE_ID;
          return true;
    }
    else
    {
      return false;
    }
  }

  Future getUserDetailsByUserNamePassword(String userName,String password) async {

    try {
      final response = await http
          .get(Uri.parse(Globle.getLoginUserURL(userName, password)));

      if (response.statusCode == 200) {
        User user = User.fromJson(jsonDecode(response.body.trim()));
        Globle.userUID = user.USR_ID;
        Globle.userName = user.USR_USER_NAME;
        Globle.userroleID = user.USER_ROLE_ID;
        await DBHelper.db.saveUser(user);
      }
      else {
        throw Exception('Failed to load User');
      }
    }
    catch(ex){
      throw Exception('Failed to load User');
    }
  }

  Future updateUserDetailsByUserNamePassword(String userName,String password) async {

    try {
      final response = await http
          .get(Uri.parse(Globle.getLoginUserURL(userName, password)));

      if (response.statusCode == 200) {
        User user = User.fromJson(jsonDecode(response.body));
        Globle.userUID = user.USR_ID;
        Globle.userName = user.USR_USER_NAME;
        Globle.userroleID = user.USER_ROLE_ID;
        await DBHelper.db.updateUserPassword(user);
      }
      else {
        throw Exception('Failed to load User');
      }
    }
    catch(ex){
      throw Exception('Failed to load User');
    }
  }

  Future createDatabaseTables() async {
      await DBHelper.db.createTables();
  }


  Future getRegisteredUserID() async
  {
      return await DBHelper.db.getRegisteredUserID();
  }

  Future getUserControlData() async{
    await DBHelper.db.getKeyValues().then((value) {
      if(value != "null") {
        List keyValueList = value.map((job) => new KeyValue.fromJson(job)).toList();
        for(int ii=0; ii<keyValueList.length;ii++){
          KeyValue kvalue = keyValueList[ii];
          if(int.parse(kvalue.ECM_VAL_KEY) == Constants.FUNCTION_KEY )
          {
            Globle.isUserFunctionDataAvailable = true;
            if(int.parse(kvalue.ECM_VAL_VALUE_2) == Constants.FUNCTION_KEY_REGISTRATION ){
              Globle.isRegistrationEnabled = true;
            }else if(int.parse(kvalue.ECM_VAL_VALUE_2) == Constants.FUNCTION_KEY_EXTERNAL_CROP_DATA){
              Globle.isECDataEnabled = true;
            }else if(int.parse(kvalue.ECM_VAL_VALUE_2) == Constants.FUNCTION_KEY_CONFIRMATION){
              Globle.isConfirmationEnabled = true;
            }else if(int.parse(kvalue.ECM_VAL_VALUE_2) == Constants.FUNCTION_KEY_REPORT){
              Globle.isReportEnabled = true;
            }
          }
        }
      }
    });
  }

}