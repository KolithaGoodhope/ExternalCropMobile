class Location{

  int locationID =0;
  String locationCode ="";
  String purchaseLocation = "" ;
  double pQty =0.0;
  double ratePerMT = 0.0;
  double penaltyPerc = 0.0;
  double penaltyCost = 0.0;

  Location({
     this.locationID,
     this.locationCode,
     this.purchaseLocation,
     this.pQty,
     this.ratePerMT,
     this.penaltyPerc,
     this.penaltyCost,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        locationID:int.parse(json['LOCATION_ID'].toString()),
        locationCode:json['LOCATION_CODE'].toString(),
        purchaseLocation: json['LOCATION_NAME'].toString(),
        pQty: double.parse(json['LOCATION_CROP_QTY'].toString()),
        ratePerMT: double.parse(json['LOCATION_CROP_RATE'].toString()),
        penaltyPerc: double.parse(json['LOCATION_CROP_PENALTY_PERCENTAGE'].toString()),
        penaltyCost: double.parse(json['LOCATION_CROP_PENALTY_COST'].toString()),
    );
  }


  Map<String, dynamic> toMap() => {
    "LOCATION_ID": locationID,
    "LOCATION_CODE": locationCode,
    "LOCATION_NAME": purchaseLocation,
    "LOCATION_CROP_QTY": pQty,
    "LOCATION_CROP_RATE": ratePerMT,
    "LOCATION_CROP_PENALTY_PERCENTAGE": penaltyPerc,
    "LOCATION_CROP_PENALTY_COST":penaltyCost,
  };
}