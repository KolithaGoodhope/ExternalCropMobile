import 'dart:io';
import 'package:external_crop/Objects/user.dart';
import 'package:external_crop/Utils/dbhelper.dart';

class Globle {

  static String Server_url ="http://138.3.214.103:9090";
//  static String Server_url ="http://10.10.32.168:9090";
  static int userUID =0;
  static String userName ="";
  static int userroleID =0;
  static bool isUserFunctionDataAvailable = false;
  static bool isRegistrationEnabled = false;
  static bool isECDataEnabled = false;
  static bool isConfirmationEnabled = false;
  static bool isReportEnabled = false;

  String version ="V1.0.1";

  Future<bool> isNetworkConnected() async {
    try {
      final result = await InternetAddress.lookup("www.google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  Future getCurrentUser() async
  {
    User user = await DBHelper.db.getUser();
    return user;
  }

  Future getAllData() async
  {
    return await DBHelper.db.generateBackup();
  }

  static String getLoginURL(String userName,String pwd,String deviceID)
  {
      String loginURL = Server_url +"/api/Login?userName="+userName+"&pw="+pwd+"&did="+deviceID+"";
      return loginURL;
  }

  static String getLoginUserURL(String userName,String pwd)
  {
    String loginURL = Server_url +"/api/Login?userName="+userName+"&pw="+pwd+" ";
    return loginURL;
  }

  static String getLocation(int userID,int type)
  {
    String locationURL = Server_url +"/api/Location?UserUID="+userID.toString()+"&locationType="+type.toString()+" ";    // locationType - 0: All, 1:Assigned only, 2: Unassigned aonly
    return locationURL;
  }

  static String getECLocation(int userID,DateTime requestdate)
  {
    String locationURL = Server_url +"/api/ECMillDetail?UserUID="+userID.toString()+"&requestDate="+requestdate.toString()+" ";
    return locationURL;
  }

  static String sendECData(String ecHeader,String ecData)  // Type  1- Save, 2 - Update
  {
    String locationURL = Server_url +"/api/ExternalCrop?ecHeaderJson="+ecHeader+"&ecDetailJson="+ecData+"&userUID="+userUID.toString()+" ";
    return locationURL;
  }

  static String getECReportData(int userID,int locationUID,DateTime month )
  {
    String locationURL = Server_url +"/api/ExternalCropReport?userUID="+userID.toString()+"&locationUID="+locationUID.toString()+"&month="+month.toString()+" ";
    return locationURL;
  }

  static String getPendingExternalCropHeader(int userID)
  {
    String locationURL = Server_url +"/api/ExternalCrop?UserUID="+userID.toString()+"";
    return locationURL;
  }

  static getExternalCropDetailsByHeaderID(int ecHeaderUID)
  {
    String locationURL = Server_url +"/api/ECMillDetail?ECHeaderUID="+ecHeaderUID.toString()+" ";
    return locationURL;
  }

  static updateECVerification(int userUID, int updateValue, int ecHeaderUID )
  {
    String locationURL = Server_url +"/api/ECHeader?userUID="+userUID.toString()+"&value="+updateValue.toString()+"&ecHeaderUID="+ecHeaderUID.toString()+" ";
    return locationURL;
  }

  static changeExistingPwd(int userUID, String existingPwd, String newpwd )
  {
    String locationURL = Server_url +"/api/Login?userId="+userUID.toString()+"&currentpwd="+existingPwd.toString()+"&newpwd="+newpwd.toString()+" ";
    return locationURL;
  }

  static String getEntityList(int userID)
  {
    String locationURL = Server_url +"/api/Entity?UserUID="+userID.toString()+"";
    return locationURL;
  }

  static String getKeyValueList(int userID, int roleID)
  {
    String locationURL = Server_url +"/api/KeyValue?UserUID="+userID.toString()+"&RoleID="+roleID.toString()+" ";
    return locationURL;
  }

  static String getVehicleList(int userID)
  {
    String locationURL = Server_url +"/api/Vehicle?UserUID="+userID.toString()+"";
    return locationURL;
  }

  static String getTempVehicleList(int userID)
  {
    String locationURL = Server_url +"/api/TempVehicle?UserUID="+userID.toString()+"";
    return locationURL;
  }

  static String getEntityVehicleList(int userID)
  {
    String locationURL = Server_url +"/api/EntityVehicle?UserUID="+userID.toString()+"";
    return locationURL;
  }

  static String sendNFCVehicleData(String jsonObjects)
  {
    String locationURL = Server_url +"/api/ECNFCVehicleDetail?jsonObjectString="+jsonObjects+"";
    return locationURL;
  }

}