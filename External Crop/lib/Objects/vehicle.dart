class Vehicle{
  int ECM_VEH_VEHICLE_ID = 0 ;
  String ECM_VEH_VEHICLE_DESCRIPTION ="";
  String ECM_VEH_ALIAS ="";
  int ECM_VEH_VEHICLE_REF_ID=0;
  int IS_TEMP = 0;

  Vehicle({
     this.ECM_VEH_VEHICLE_ID,
     this.ECM_VEH_VEHICLE_DESCRIPTION,
     this.ECM_VEH_ALIAS,
     this.ECM_VEH_VEHICLE_REF_ID,
     this.IS_TEMP,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      ECM_VEH_VEHICLE_ID: json['ECM_VEH_VEHICLE_ID'],
      ECM_VEH_VEHICLE_DESCRIPTION: json['ECM_VEH_VEHICLE_DESCRIPTION'],
      ECM_VEH_ALIAS: json['ECM_VEH_ALIAS'],
      ECM_VEH_VEHICLE_REF_ID: json['ECM_VEH_VEHICLE_REF_ID'],
      IS_TEMP:json['IS_TEMP'],
    );
  }


  Map<String, dynamic> toMap() => {
    "ECM_VEH_VEHICLE_ID": ECM_VEH_VEHICLE_ID,
    "ECM_VEH_VEHICLE_DESCRIPTION": ECM_VEH_VEHICLE_DESCRIPTION,
    "ECM_VEH_ALIAS": ECM_VEH_ALIAS,
    "ECM_VEH_VEHICLE_REF_ID":ECM_VEH_VEHICLE_REF_ID,
    "IS_TEMP":IS_TEMP,
  };
}