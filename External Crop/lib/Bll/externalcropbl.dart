import 'dart:convert';
import 'package:external_crop/Objects/locationheader.dart';
import 'package:external_crop/Utils/globl.dart';
import 'package:http/http.dart'  as http;
import 'package:external_crop/Objects/externalcrop.dart';
import 'package:external_crop/Objects/ecmilldetail.dart';

class ExternalCropBL{

  Future getLocationDetailsByDate(DateTime date) async
  {
    try {

    final response = await http
        .get(Uri.parse(Globle.getECLocation(Globle.userUID, date)));

      if (response.statusCode == 200) {
        if (response.body != "null") {
            Map<String, dynamic> jsonmap = json.decode(response.body);
            var ecMillDetailList = jsonmap["ECH_ECMILL_DETAIL_LIST"];
            List<ECMillDetail> millList = [];
            for (int xx = 0; xx < ecMillDetailList.length; xx++) {
              ECMillDetail loc = new ECMillDetail(
                  millID: ecMillDetailList[xx]["MILL_ID"],
                  millCode: ecMillDetailList[xx]["MILL_CODE"],
                  purchaseMillName: ecMillDetailList[xx]["MILL_NAME"],
                  pQty: ecMillDetailList[xx]["MILL_CROP_QTY"].toDouble(),
                  ratePerMT: ecMillDetailList[xx]["MILL_CROP_RATE"],
                  penaltyPerc: ecMillDetailList[xx]["MILL_CROP_PENALTY_PERCENTAGE"],
                  penaltyCost: ecMillDetailList[xx]["MILL_CROP_PENALTY_COST"],
                  companyID:ecMillDetailList[xx]["COMPANY_ID"],
                  supplierID: ecMillDetailList[xx]["SUPPLIER_ID"],
                  supplierName: ecMillDetailList[xx]["SUPPLIER_NAME"],
              );
              millList.add(loc);
            }
            LocationHeader lHeader = LocationHeader(
                ECH_ID: jsonmap["ECH_ID"],
                ECH_PURCHASED_ID: (jsonmap["ECH_PURCHASED_ID"] == null? "": jsonmap["ECH_PURCHASED_ID"]),
                ECH_INCENTIVE_PER_MT: jsonmap["ECH_INCENTIVE_PER_MT"],
                ECH_TOTAL_PURCHASED_QTY: jsonmap["ECH_TOTAL_PURCHASED_QTY"],
                ECH_INCENTIVE: jsonmap["ECH_INCENTIVE"],
                ECH_EXTERNAL_CROP_COST: jsonmap["ECH_EXTERNAL_CROP_COST"],
                ECH_COST_AVG_PER_MT: jsonmap["ECH_COST_AVG_PER_MT"],
                ECH_TOTAL_PENALTY_COST: jsonmap["ECH_TOTAL_PENALTY_COST"],
                ECH_COST_AFTER_PENALTY: jsonmap["ECH_COST_AFTER_PENALTY"],
                ECH_CONFIRMED: jsonmap["ECH_CONFIRMED"],
                ecMillDetailList: millList,
                ECH_PURCHASE_DATE: DateTime.parse(jsonmap["ECH_PURCHASE_DATE"]),
                isUpdate: false);
            return lHeader;
        }
        else {
          List<ECMillDetail> millList = [];
          LocationHeader locHeader = LocationHeader(
              ECH_ID: -1,
              ECH_PURCHASED_ID: "",
              ECH_INCENTIVE_PER_MT: 0.0,
              ECH_TOTAL_PURCHASED_QTY: 0,
              ECH_INCENTIVE: 0.0,
              ECH_EXTERNAL_CROP_COST: 0.0,
              ECH_COST_AVG_PER_MT: 0.0,
              ECH_TOTAL_PENALTY_COST: 0.0,
              ECH_COST_AFTER_PENALTY: 0.0,
              ECH_CONFIRMED: 0,
              ecMillDetailList: millList,
              ECH_PURCHASE_DATE: DateTime.parse("1900-01-01"),
              isUpdate: false);
          return locHeader;
        }
      } else {
        return null;
      }
    }
    catch(excep)
    {
      return null;
    }
  }

  ExternalCropOb getExternalCropSummary(List<ECMillDetail> ecMillDetailList,String incentivePerMTVal)
  {
    double totalPurchasedQTY = 0,incentivePerMT = 0.0,incentiveTotal = 0,externalCropCost=0,costAveragePerMT=0,totalPenaltyCost=0,externalCropCostAfterPenalty=0;
    incentivePerMT = incentivePerMTVal.trim() == ""? 0:double.parse(incentivePerMTVal);
    for(var i = 0;i<ecMillDetailList.length;i++)
    {
      if(ecMillDetailList[i].pQty>0 /*&& ecMillDetailList[i].ratePerMT> 0*/) {
        totalPurchasedQTY = totalPurchasedQTY + ecMillDetailList[i].pQty;
        externalCropCost = externalCropCost +
            (ecMillDetailList[i].pQty * ecMillDetailList[i].ratePerMT);
        totalPenaltyCost = totalPenaltyCost +
            (ecMillDetailList[i].pQty * ecMillDetailList[i].ratePerMT *
                ecMillDetailList[i].penaltyPerc / 100);
      }
    }
    incentiveTotal = totalPurchasedQTY * incentivePerMT;
    externalCropCost = externalCropCost + incentiveTotal;
    if(totalPurchasedQTY>0){
      costAveragePerMT = externalCropCost / totalPurchasedQTY;
    }
    externalCropCostAfterPenalty = externalCropCost - totalPenaltyCost;
    ExternalCropOb externalCrop = ExternalCropOb(totalPurchasedQTY: totalPurchasedQTY, incentivePerMT: incentivePerMT, incentiveTotal: incentiveTotal, externalCropCost: externalCropCost, costAveragePerMT: costAveragePerMT, totalPenaltyCost: totalPenaltyCost, externalCropCostAfterPenalty: externalCropCostAfterPenalty);
    return externalCrop;
  }

  double calculateLocationPenaltyCostByLocation(ECMillDetail location)
  {
    double locationPenaltyCost = location.pQty * location.ratePerMT * location.penaltyPerc / 100;
    return locationPenaltyCost;
  }
/*
  Future getnotAssignedMills() async
  {
    try {
      final response = await http
          .get(Uri.parse(Globle.getLocation(Globle.userUID, 2)));

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((job) => new Mill.fromJson(job)).toList();
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
*/
  Future sendExternalCropData(String ecHeader,String ecData) async
  {
    try {
      final response = await http
          .get(Uri.parse(Globle.sendECData(ecHeader, ecData)));

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        String responseVal = json.decode(response.body).toString();
        if (responseVal.trim() == "1") {
          return true;
        } else {
          return false;
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