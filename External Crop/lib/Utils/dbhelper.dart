import 'dart:async';
import 'dart:io';
import 'package:external_crop/Objects/NFCVehicleDetail.dart';
import 'package:external_crop/Objects/entity.dart';
import 'package:external_crop/Objects/entityvehicle.dart';
import 'package:external_crop/Objects/keyvalue.dart';
import 'package:external_crop/Objects/tempVehicle.dart';
import 'package:external_crop/Objects/user.dart';
import 'package:external_crop/Objects/vehicle.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert' as convert;

class DBHelper {

  DBHelper._();
  static final DBHelper db = DBHelper._();
  List<String> tables =["ECM_M_USERS","ECM_M_ENTITY","ECM_M_ENTITY_VEHICLE_MAPPING","ECM_M_VEHICLE","ECM_M_KEY_VALUES","ECM_M_TEMP_VEHICLE_LIST"];

  Future<Database> get database async {
    // if _database is null we instantiate it
    Database _database = await initDB();
    return _database;
  }


  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "External_Crop.db");
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE IF NOT EXISTS ECM_M_USERS(USR_ID INTEGER PRIMARY KEY, USR_USER_NAME TEXT, USR_PASSWORD TEXT, USER_ROLE_ID INTEGER )");
    });
  }

  createTables() async{
    final db = await database;
    db.execute("CREATE TABLE IF NOT EXISTS ECM_M_ENTITY(ECM_ENTITY_ID INTEGER PRIMARY KEY, ECM_ENTITY_DESCRIPTION TEXT, ECM_ALIAS TEXT, ECM_ENTITY_REF_ID INTEGER, ECM_ENTITY_REF_PARENT_ID INTEGER, ECM_ENTITY_TYPE INTEGER )");
    db.execute("CREATE TABLE IF NOT EXISTS ECM_M_ENTITY_VEHICLE_MAPPING(ECM_ENT_VEH_MAP_ID INTEGER PRIMARY KEY, ECM_ENT_VEH_MAP_ENTITY_REF_ID TEXT, ECM_ENT_VEH_MAP_VEHICLE_REF_ID TEXT )");
    db.execute("CREATE TABLE IF NOT EXISTS ECM_M_VEHICLE(ECM_VEH_VEHICLE_ID INTEGER PRIMARY KEY, ECM_VEH_VEHICLE_DESCRIPTION TEXT, ECM_VEH_ALIAS TEXT, ECM_VEH_VEHICLE_REF_ID INTEGER )");
    db.execute("CREATE TABLE IF NOT EXISTS ECM_T_NFC_VEHICLE_DETAIL(USER_ID INTEGER, ENTITY_ID INTEGER, VEHICLE_ID INTEGER, DATE TEXT, EC_NFC_IS_TEMP_VEHICLE INTEGER )");
    db.execute("CREATE TABLE IF NOT EXISTS ECM_M_KEY_VALUES(ECM_VAL_ID INTEGER, ECM_VAL_KEY TEXT, ECM_VAL_VALUE TEXT, ECM_VAL_DESCRIPTION TEXT, ECM_VAL_ACTIVE INTEGER, ECM_VAL_VALUE_2 TEXT )");
    db.execute("CREATE TABLE IF NOT EXISTS ECM_M_TEMP_VEHICLE_LIST(ECM_TEMP_VEH_LIST_VEHICLE_ID INTEGER PRIMARY KEY, ECM_TEMP_VEH_LIST_VEHICLE_DESCRIPTION TEXT, ECM_TEMP_VEH_LIST_ALIAS TEXT, ECM_TEMP_VEH_LIST_IS_ASSIGNED INTEGER )");
/*
    var res = await db.rawInsert(
        "INSERT Into ECM_T_NFC_VEHICLE_DETAIL(USER_ID,ENTITY_ID,VEHICLE_ID,DATE)"
            " VALUES (?,?,?,?)",
        [1, 2, 4, DateTime.now().toString()]);

    var res1 = await db.rawInsert(
        "INSERT Into ECM_T_NFC_VEHICLE_DETAIL(USER_ID,ENTITY_ID,VEHICLE_ID,DATE)"
            " VALUES (?,?,?,?)",
        [1, 1, 3, DateTime.now().toString()]);
*/
  }

  clearTables() async{
    final db = await database;
    db.execute("DELETE FROM ECM_M_ENTITY ");
    db.execute("DELETE FROM ECM_M_ENTITY_VEHICLE_MAPPING ");
    db.execute("DELETE FROM ECM_M_VEHICLE ");
    db.execute("DELETE FROM ECM_M_KEY_VALUES ");
    db.execute("DELETE FROM ECM_M_TEMP_VEHICLE_LIST ");
  }

  clearTransActionTables() async{
    final db = await database;
    db.execute("DELETE FROM ECM_T_NFC_VEHICLE_DETAIL ");
  }

  saveUser(User newUser) async {
    final db = await database;
    var res = await db.rawInsert(
        "INSERT Into ECM_M_USERS(USR_ID,USR_USER_NAME,USR_PASSWORD,USER_ROLE_ID)"
            " VALUES (?,?,?,?)",
        [newUser.USR_ID, newUser.USR_USER_NAME, newUser.USR_PASSWORD, newUser.USER_ROLE_ID]);

    return res;
  }

  saveNFCVehicleDetail(NFCVehicleDetail vehicleDetail) async {
    try {
      final db = await database;
      var res = await db.rawInsert(
          "INSERT Into ECM_T_NFC_VEHICLE_DETAIL(USER_ID,ENTITY_ID,VEHICLE_ID,DATE,EC_NFC_IS_TEMP_VEHICLE)"
              " VALUES (?,?,?,?,?)",
          [
            vehicleDetail.USER_ID,
            vehicleDetail.ENTITY_ID,
            vehicleDetail.VEHICLE_ID,
            vehicleDetail.DATE.toString(),
            vehicleDetail.EC_NFC_IS_TEMP_VEHICLE,
          ]);

      return 1;
    }
    catch(Ex)
    {
      return -1;
    }
  }

  updateUsedTempVehicleByVehicleID(int vehicleID) async {
    final db = await database;
    var res = await db.rawQuery("UPDATE ECM_M_TEMP_VEHICLE_LIST SET ECM_TEMP_VEH_LIST_IS_ASSIGNED ='1' WHERE ECM_TEMP_VEH_LIST_VEHICLE_ID =?",[vehicleID]);
    return 1;
  }

  saveEntities(Entity newEntity) async {
    final db = await database;
    var res = await db.rawInsert(
        "INSERT Into ECM_M_ENTITY(ECM_ENTITY_ID,ECM_ENTITY_DESCRIPTION,ECM_ALIAS,ECM_ENTITY_REF_ID,ECM_ENTITY_REF_PARENT_ID,ECM_ENTITY_TYPE)"
            " VALUES (?,?,?,?,?,?)",
        [newEntity.ECM_ENTITY_ID, newEntity.ECM_ENTITY_DESCRIPTION, newEntity.ECM_ENTITY_DESCRIPTION,newEntity.ECM_ENTITY_REF_ID,newEntity.ECM_ENTITY_REF_PARENT_ID,newEntity.ECM_ENTITY_TYPE]);

    return res;
  }

  saveKeyValues(KeyValue newKeyValue) async {
    final db = await database;
    var res = await db.rawInsert(
        "INSERT Into ECM_M_KEY_VALUES(ECM_VAL_ID , ECM_VAL_KEY, ECM_VAL_VALUE, ECM_VAL_DESCRIPTION, ECM_VAL_ACTIVE, ECM_VAL_VALUE_2 )"
            " VALUES (?,?,?,?,?,?)",
        [newKeyValue.ECM_VAL_ID, newKeyValue.ECM_VAL_KEY, newKeyValue.ECM_VAL_VALUE,newKeyValue.ECM_VAL_DESCRIPTION,newKeyValue.ECM_VAL_ACTIVE,newKeyValue.ECM_VAL_VALUE_2]);

    return res;
  }

  saveVehicles(Vehicle newEntity) async {
    final db = await database;
    var res = await db.rawInsert(
        "INSERT Into ECM_M_VEHICLE(ECM_VEH_VEHICLE_ID,ECM_VEH_VEHICLE_DESCRIPTION,ECM_VEH_ALIAS,ECM_VEH_VEHICLE_REF_ID)"
            " VALUES (?,?,?,?)",
        [newEntity.ECM_VEH_VEHICLE_ID, newEntity.ECM_VEH_VEHICLE_DESCRIPTION, newEntity.ECM_VEH_ALIAS,newEntity.ECM_VEH_VEHICLE_REF_ID]);

    return res;
  }

  saveTempVehicles(TempVehicle newEntity) async {
    final db = await database;
    var res = await db.rawInsert(
        "INSERT Into ECM_M_TEMP_VEHICLE_LIST(ECM_TEMP_VEH_LIST_VEHICLE_ID, ECM_TEMP_VEH_LIST_VEHICLE_DESCRIPTION, ECM_TEMP_VEH_LIST_ALIAS, ECM_TEMP_VEH_LIST_IS_ASSIGNED)"
            " VALUES (?,?,?,?)",
        [newEntity.ECM_TEMP_VEH_LIST_VEHICLE_ID, newEntity.ECM_TEMP_VEH_LIST_VEHICLE_DESCRIPTION, newEntity.ECM_TEMP_VEH_LIST_ALIAS,newEntity.ECM_TEMP_VEH_LIST_IS_ASSIGNED]);

    return res;
  }

  saveEntityVehicleMapping(EntityVehicleMap newEntity) async {
    final db = await database;
    var res = await db.rawInsert(
        "INSERT Into ECM_M_ENTITY_VEHICLE_MAPPING(ECM_ENT_VEH_MAP_ID,ECM_ENT_VEH_MAP_ENTITY_REF_ID,ECM_ENT_VEH_MAP_VEHICLE_REF_ID)"
            " VALUES (?,?,?)",
        [newEntity.ECM_ENT_VEH_MAP_ID, newEntity.ECM_ENT_VEH_MAP_ENTITY_REF_ID, newEntity.ECM_ENT_VEH_MAP_VEHICLE_REF_ID]);

    return res;
  }

  Future<List> getNFCVehicleDetail() async {
    final db = await database;
    var result = await db.query("ECM_T_NFC_VEHICLE_DETAIL", columns: ["USER_ID", "ENTITY_ID", "VEHICLE_ID", "DATE", "EC_NFC_IS_TEMP_VEHICLE"]);
    return result.toList();
  }

  updateUserPassword(User newUser) async {
    final db = await database;
    var res = await db.rawQuery("UPDATE ECM_M_USERS SET USR_PASSWORD =? WHERE USR_ID =?",[newUser.USR_PASSWORD,newUser.USR_ID]);
    return res;
  }

  getUser() async {
    final db = await database;
    var res =await  db.rawQuery('SELECT * FROM ECM_M_USERS') ;
    return res.isNotEmpty ? User.fromJson(res.first) : Null ;
  }

  Future<bool> checkUserByUserNameAndPassword() async {
    final db = await database;
    var res =await  db.rawQuery('SELECT * FROM ECM_M_USERS') ;
    return res.isNotEmpty ? true : false ;

  }

  Future<String> getRegisteredUserID() async {
    final db = await database;
    var res =await  db.rawQuery('SELECT USR_USER_NAME FROM ECM_M_USERS') ;
    if(res.isNotEmpty) {
      var dbItem = res.first;
      return dbItem['USR_USER_NAME'] as String ;
    }
    return "";
  }

  Future<List> getEntities() async {
    final db = await database;
    var result = await db.query("ECM_M_ENTITY", columns: ["ECM_ENTITY_ID", "ECM_ENTITY_DESCRIPTION", "ECM_ALIAS","ECM_ENTITY_REF_ID", "ECM_ENTITY_REF_PARENT_ID INTEGER", "ECM_ENTITY_TYPE INTEGER"]);
    return result.toList();
  }

  Future<List> getKeyValues() async {
    final db = await database;
    var result = await db.query("ECM_M_KEY_VALUES", columns: ["ECM_VAL_ID", "ECM_VAL_KEY", "ECM_VAL_VALUE","ECM_VAL_DESCRIPTION","ECM_VAL_ACTIVE","ECM_VAL_VALUE_2"]);
    return result.toList();
  }

  Future<List> getVehiclesByEntityID(int entityUID) async {
    try {
      final db = await database;
      var res;

      if(entityUID > 0) {
        res = await db.rawQuery(
            "SELECT veh.ECM_VEH_VEHICLE_REF_ID,veh.ECM_VEH_VEHICLE_DESCRIPTION,veh.ECM_VEH_ALIAS, 0 AS IS_TEMP FROM ECM_M_VEHICLE veh "
                "INNER JOIN ECM_M_ENTITY_VEHICLE_MAPPING mp ON CAST(veh.ECM_VEH_VEHICLE_REF_ID AS INTEGER) = CAST(mp.ECM_ENT_VEH_MAP_VEHICLE_REF_ID AS INTEGER)"
                "WHERE mp.ECM_ENT_VEH_MAP_ENTITY_REF_ID =? "
                "UNION "
                "SELECT TVEH.ECM_TEMP_VEH_LIST_VEHICLE_ID  AS ECM_VEH_VEHICLE_REF_ID , TVEH.ECM_TEMP_VEH_LIST_VEHICLE_DESCRIPTION  AS ECM_VEH_VEHICLE_DESCRIPTION, TVEH.ECM_TEMP_VEH_LIST_ALIAS AS ECM_VEH_ALIAS , 1 AS IS_TEMP "
                "FROM ECM_M_TEMP_VEHICLE_LIST TVEH WHERE TVEH.ECM_TEMP_VEH_LIST_IS_ASSIGNED = '0' ORDER BY IS_TEMP",
            [entityUID]);
      }else{
        res = await db.rawQuery(
            "SELECT veh.ECM_VEH_VEHICLE_REF_ID,veh.ECM_VEH_VEHICLE_DESCRIPTION,veh.ECM_VEH_ALIAS, 0 AS IS_TEMP FROM ECM_M_VEHICLE veh "
                "INNER JOIN ECM_M_ENTITY_VEHICLE_MAPPING mp ON CAST(veh.ECM_VEH_VEHICLE_REF_ID AS INTEGER) = CAST(mp.ECM_ENT_VEH_MAP_VEHICLE_REF_ID AS INTEGER)"
                "WHERE mp.ECM_ENT_VEH_MAP_ENTITY_REF_ID =? ",[entityUID]);
      }

      return res.toList();
    }
    catch(exception){
      return [];

    }
  }

  Future<bool> getIsAvailableTempVehicleByVehID(int vehicleID) async {
    final db = await database;
    var res =await  db.rawQuery("SELECT ECM_TEMP_VEH_LIST_VEHICLE_ID FROM ECM_M_TEMP_VEHICLE_LIST WHERE ECM_TEMP_VEH_LIST_IS_ASSIGNED = '1' AND ECM_TEMP_VEH_LIST_VEHICLE_ID =?",[vehicleID]) ;
    return res.isEmpty ? true : false ;

  }

  Future<List> getVehicles() async {
    try {
      final db = await database;

      var res = await db.rawQuery("SELECT veh.ECM_VEH_VEHICLE_REF_ID AS ECM_VEH_VEHICLE_REF_ID,veh.ECM_VEH_VEHICLE_DESCRIPTION AS ECM_VEH_VEHICLE_DESCRIPTION,veh.ECM_VEH_ALIAS AS ECM_VEH_ALIAS, 0 AS IS_TEMP FROM ECM_M_VEHICLE veh "
          "UNION SELECT TVEH.ECM_TEMP_VEH_LIST_VEHICLE_ID  AS ECM_VEH_VEHICLE_REF_ID , TVEH.ECM_TEMP_VEH_LIST_VEHICLE_DESCRIPTION  AS ECM_VEH_VEHICLE_DESCRIPTION, TVEH.ECM_TEMP_VEH_LIST_ALIAS AS ECM_VEH_ALIAS , 1 AS IS_TEMP FROM ECM_M_TEMP_VEHICLE_LIST TVEH WHERE TVEH.ECM_TEMP_VEH_LIST_IS_ASSIGNED = '0' ORDER BY IS_TEMP ");

      return res.toList();
    }
    catch(exception){
      return [];
    }
  }

  Future<String>generateBackup() async {

    var dbs = await database;

    List data =[];
    List<Map<String,dynamic>> listMaps=[];

    for (var i = 0; i < tables.length; i++)
    {
      listMaps = await dbs.query(tables[i]);
      data.add(listMaps);
    }
    List backups=[tables,data];
    String json = convert.jsonEncode(backups);
    return json;
  }


  Future<List> getEntitiesByVehicleID(int vehicleID, int isTempVehicle) async {
    try {
      final db = await database;
      var res;

      if(isTempVehicle == 0) {
        res = await db.rawQuery("SELECT DISTINCT(EN.ECM_ENTITY_ID), EN.ECM_ENTITY_DESCRIPTION, EN.ECM_ALIAS,EN.ECM_ENTITY_REF_ID, EN.ECM_ENTITY_REF_PARENT_ID, EN.ECM_ENTITY_TYPE FROM ECM_M_ENTITY EN "
                "INNER JOIN ECM_M_ENTITY_VEHICLE_MAPPING MP ON CAST(EN.ECM_ENTITY_REF_ID AS INTEGER) = CAST(MP.ECM_ENT_VEH_MAP_ENTITY_REF_ID AS INTEGER)"
                "WHERE MP.ECM_ENT_VEH_MAP_VEHICLE_REF_ID =?", [vehicleID]);
      }
      else
      {
        res = await db.rawQuery("SELECT DISTINCT(EN.ECM_ENTITY_ID), EN.ECM_ENTITY_DESCRIPTION, EN.ECM_ALIAS,EN.ECM_ENTITY_REF_ID, EN.ECM_ENTITY_REF_PARENT_ID, EN.ECM_ENTITY_TYPE FROM ECM_M_ENTITY EN ");
      }

      return res.toList();
    }
    catch(exception){
      return [];
    }
  }

  Future<List> getAllSupplierList() async {
    try {
      final db = await database;
      var res = await db.rawQuery("SELECT DISTINCT(EN.ECM_ENTITY_ID), EN.ECM_ENTITY_DESCRIPTION, EN.ECM_ALIAS,EN.ECM_ENTITY_REF_ID, EN.ECM_ENTITY_REF_PARENT_ID, EN.ECM_ENTITY_TYPE FROM ECM_M_ENTITY EN WHERE EN.ECM_ENTITY_TYPE ='6' OR EN.ECM_ENTITY_TYPE ='7' ");

      return res.toList();
    }
    catch(exception){
      return [];
    }
  }

}