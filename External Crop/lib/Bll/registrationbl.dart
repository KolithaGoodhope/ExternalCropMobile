import 'dart:convert';
import 'package:external_crop/Objects/NFCVehicleDetail.dart';
import 'package:external_crop/Objects/entity.dart';
import 'package:external_crop/Objects/vehicle.dart';
import 'package:http/http.dart'  as http;
import 'package:external_crop/Utils/dbhelper.dart';
import 'package:external_crop/Utils/globl.dart';

class RegistrationBL{

  Future  getAssignedMills() async
  {
    try {
      List entities = await DBHelper.db.getEntities();
     List<Entity> entitiyList = entities.map((job) => new Entity.fromJson(job)).toList();

      return entitiyList;
    }
    catch(Exception)
    {
      return null;
    }
  }

  Future  getAssignedMillsByVehicleID(int ownerID,int isTempVehicle) async
  {
    try {
      List entities = await DBHelper.db.getEntitiesByVehicleID(ownerID,isTempVehicle);
      List<Entity> entitiyList = entities.map((job) => new Entity.fromJson(job)).toList();

      return entitiyList;
    }
    catch(Exception)
    {
      return null;
    }
  }

  Future  getAllSupplierList() async
  {
    try {
      List entities = await DBHelper.db.getAllSupplierList();
      List<Entity> entitiyList = entities.map((job) => new Entity.fromJson(job)).toList();

      return entitiyList;
    }
    catch(Exception)
    {
      return null;
    }
  }

  Future getVehiclesByEntityID(int entityID) async
  {
    try {
      List<Vehicle> vehicleList =[];
      await DBHelper.db.getVehiclesByEntityID(entityID).then((value) {
        if(value != "null") {
          vehicleList = value.map((job) => new Vehicle.fromJson(job)).toList();
        }
      });
      return vehicleList;
    }
    catch(Exception)
    {
      return [];
    }
  }

  Future getVehicles() async
  {
    try {
      List<Vehicle> vehicleList =[];
      await DBHelper.db.getVehicles().then((value) {
        if(value != "null") {
          vehicleList = value.map((job) => new Vehicle.fromJson(job)).toList();
        }
      });
      return vehicleList;
    }
    catch(Exception)
    {
      return [];
    }
  }

  Future<int>  saveNFCVehicleData(int entityID,int vehicleID,int isTempVehicle) async
  {
    int result = -1;
    try {
      NFCVehicleDetail NFCvehicleDetail = NFCVehicleDetail(USER_ID:Globle.userUID, ENTITY_ID: entityID, VEHICLE_ID: vehicleID, DATE: DateTime.now().toString(),EC_NFC_IS_TEMP_VEHICLE:isTempVehicle );
      await DBHelper.db.saveNFCVehicleDetail(NFCvehicleDetail).then((value){
        if(value == 1){
          result = 1;
        }
        else{
          result = -1;
        }
      });
      return result;
    }
    catch(exception){
      return result;
    }
  }

  Future<int>  updateUsedTempVehicleByVehicleID(int vehicleID) async
  {
    int result = -1;
    try {
      await DBHelper.db.updateUsedTempVehicleByVehicleID(vehicleID).then((value){
        if(value == 1){
          result = 1;
        }
        else{
          result = -1;
        }
      });
      return result;
    }
    catch(exception){
      return result;
    }
  }

  Future<bool>  getIsAvailableTempVehByVehID(int vehicleID) async
  {
    bool result = false;
    try {
      await DBHelper.db.getIsAvailableTempVehicleByVehID(vehicleID).then((value){
        if(value == true){
          result = true;
        }
      });
      return result;
    }
    catch(exception){
      return result;
    }
  }

}