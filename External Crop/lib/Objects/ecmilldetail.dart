class ECMillDetail{

  int millID =0;
  String millCode ="";
  String purchaseMillName = "" ;
  double pQty =0.0;
  double ratePerMT = 0.0;
  double penaltyPerc = 0.0;
  double penaltyCost = 0.0;
  int companyID =0;
  int supplierID = 0;
  String supplierName ="";

  ECMillDetail({
     this.millID,
     this.millCode,
     this.purchaseMillName,
     this.pQty,
     this.ratePerMT,
     this.penaltyPerc,
     this.penaltyCost,
     this.companyID,
     this.supplierID,
     this.supplierName,
  });

  factory ECMillDetail.fromJson(Map<String, dynamic> json) {
    return ECMillDetail(
      millID:int.parse(json['MILL_ID'].toString()),
      millCode:json['MILL_CODE'].toString(),
      purchaseMillName: json['MILL_NAME'].toString(),
      pQty: double.parse(json['MILL_CROP_QTY'].toString()),
      ratePerMT: double.parse(json['MILL_CROP_RATE'].toString()),
      penaltyPerc: double.parse(json['MILL_CROP_PENALTY_PERCENTAGE'].toString()),
      penaltyCost: double.parse(json['MILL_CROP_PENALTY_COST'].toString()),
      companyID:int.parse(json['COMPANY_ID'].toString()),
      supplierID:int.parse(json['SUPPLIER_ID'].toString()),
      supplierName:json['SUPPLIER_NAME'].toString(),
    );
  }


  Map<String, dynamic> toMap() => {
    "LOCATION_ID": millID,
    "LOCATION_CODE": millCode,
    "LOCATION_NAME": purchaseMillName,
    "LOCATION_CROP_QTY": pQty,
    "LOCATION_CROP_RATE": ratePerMT,
    "LOCATION_CROP_PENALTY_PERCENTAGE": penaltyPerc,
    "LOCATION_CROP_PENALTY_COST":penaltyCost,
    "COMPANY_ID":companyID,
    "SUPPLIER_ID":supplierID,
    "SUPPLIER_NAME":supplierName,
  };
}