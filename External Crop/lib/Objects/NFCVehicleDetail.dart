class NFCVehicleDetail{
  int USER_ID = 0 ;
  int ENTITY_ID = 0 ;
  int VEHICLE_ID = 0 ;
  String DATE ="";
  int EC_NFC_IS_TEMP_VEHICLE = 0;

  NFCVehicleDetail({
     this.USER_ID,
     this.ENTITY_ID,
     this.VEHICLE_ID,
     this.DATE,
     this.EC_NFC_IS_TEMP_VEHICLE,
  });

  factory NFCVehicleDetail.fromJson(Map<String, dynamic> json) {
    return NFCVehicleDetail(
      USER_ID: json['USER_ID'],
      ENTITY_ID: json['ENTITY_ID'],
      VEHICLE_ID: json['VEHICLE_ID'],
      DATE:json["DATE"],
      EC_NFC_IS_TEMP_VEHICLE:json["EC_NFC_IS_TEMP_VEHICLE"],
    );
  }
  Map<String, dynamic> toJson() => {
    "USER_ID": USER_ID,
    "ENTITY_ID": ENTITY_ID,
    "VEHICLE_ID": VEHICLE_ID,
    "DATE":DATE,
    "EC_NFC_IS_TEMP_VEHICLE":EC_NFC_IS_TEMP_VEHICLE,
  };

}