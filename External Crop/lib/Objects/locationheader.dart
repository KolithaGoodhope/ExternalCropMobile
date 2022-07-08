import 'package:external_crop/Objects/ecmilldetail.dart';
import 'package:external_crop/Objects/location.dart';

class LocationHeader{

  int ECH_ID =0;
  String ECH_PURCHASED_ID ="";
  double ECH_INCENTIVE_PER_MT =0;
  int ECH_TOTAL_PURCHASED_QTY =0;
  double ECH_INCENTIVE = 0.0 ;
  double ECH_EXTERNAL_CROP_COST =0.0;
  double ECH_COST_AVG_PER_MT = 0.0;
  double ECH_TOTAL_PENALTY_COST = 0.0;
  double ECH_COST_AFTER_PENALTY = 0.0;
  int ECH_CONFIRMED = 0;
  DateTime ECH_PURCHASE_DATE = DateTime.now();
  List<ECMillDetail> ecMillDetailList = [];
  bool isUpdate = false;

  LocationHeader({
     this.ECH_ID,
     this.ECH_PURCHASED_ID,
     this.ECH_INCENTIVE_PER_MT,
     this.ECH_TOTAL_PURCHASED_QTY,
     this.ECH_INCENTIVE,
     this.ECH_EXTERNAL_CROP_COST,
     this.ECH_COST_AVG_PER_MT,
     this.ECH_TOTAL_PENALTY_COST,
     this.ECH_COST_AFTER_PENALTY,
     this.ECH_CONFIRMED,
     this.ecMillDetailList,
     this.ECH_PURCHASE_DATE,
     this.isUpdate,
  });

  factory LocationHeader.fromJson(Map<String, dynamic> json) {
    return LocationHeader(
      ECH_ID:int.parse(json['ECH_ID'].toString()),
      ECH_PURCHASED_ID:json['ECH_PURCHASED_ID'].toString(),
      ECH_INCENTIVE_PER_MT:double.parse(json['ECH_INCENTIVE_PER_MT'].toString()),
      ECH_TOTAL_PURCHASED_QTY: int.parse(json['ECH_TOTAL_PURCHASED_QTY'].toString()),
      ECH_INCENTIVE: double.parse(json['ECH_INCENTIVE'].toString()),
      ECH_EXTERNAL_CROP_COST: double.parse(json['ECH_EXTERNAL_CROP_COST'].toString()),
      ECH_COST_AVG_PER_MT: double.parse(json['ECH_COST_AVG_PER_MT'].toString()),
      ECH_TOTAL_PENALTY_COST: double.parse(json['ECH_TOTAL_PENALTY_COST'].toString()),
      ECH_COST_AFTER_PENALTY: double.parse(json['ECH_COST_AFTER_PENALTY'].toString()),
      ECH_CONFIRMED:int.parse(json['ECH_CONFIRMED'].toString()),
      ecMillDetailList:[],
      ECH_PURCHASE_DATE: DateTime.parse(json['ECH_PURCHASE_DATE'].toString()),
      isUpdate:false,
    );
  }


  Map<String, dynamic> toMap() => {
    "ECH_ID":ECH_ID,
    "ECH_PURCHASED_ID": ECH_PURCHASED_ID,
    "ECH_INCENTIVE_PER_MT": ECH_INCENTIVE_PER_MT,
    "ECH_TOTAL_PURCHASED_QTY": ECH_TOTAL_PURCHASED_QTY,
    "ECH_INCENTIVE": ECH_INCENTIVE,
    "ECH_EXTERNAL_CROP_COST": ECH_EXTERNAL_CROP_COST,
    "ECH_COST_AVG_PER_MT": ECH_COST_AVG_PER_MT,
    "ECH_TOTAL_PENALTY_COST": ECH_TOTAL_PENALTY_COST,
    "ECH_COST_AFTER_PENALTY":ECH_COST_AFTER_PENALTY,
    "ECH_PURCHASE_DATE":ECH_PURCHASE_DATE.toString(),
  };
}