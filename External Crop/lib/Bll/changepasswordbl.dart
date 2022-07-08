import 'dart:convert';
import 'package:external_crop/Objects/locationheader.dart';
import 'package:external_crop/Objects/ecmilldetail.dart';
import 'package:external_crop/Objects/user.dart';
import 'package:external_crop/Utils/dbhelper.dart';
import 'package:external_crop/Utils/globl.dart';
import 'package:http/http.dart'  as http;

class ChangePasswordBL{

  Future changeExsistingPassword(String currentpwd ,String newPwd) async
  {
    try {
      final response = await http
          .get(Uri.parse(Globle.changeExistingPwd(Globle.userUID,currentpwd,newPwd)));

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        if (response.body != "null") {
          String responseVal = json.decode(response.body).toString();
          return responseVal;
        }
        else{
          return null;
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

  Future updatePasswordByUser(int userID,String password) async {
    try {
      User user = User(USR_ID: userID, USR_USER_NAME: Globle.userName, USR_PASSWORD: password);
      await DBHelper.db.updateUserPassword(user);
      return 1;
    }
    catch(exception){
      return 0;
    }
  }

}