class TempVehicle{
  int ECM_TEMP_VEH_LIST_VEHICLE_ID = 0 ;
  String ECM_TEMP_VEH_LIST_VEHICLE_DESCRIPTION ="";
  String ECM_TEMP_VEH_LIST_ALIAS ="";
  int ECM_TEMP_VEH_LIST_IS_ASSIGNED=0;

  TempVehicle({
    this.ECM_TEMP_VEH_LIST_VEHICLE_ID,
    this.ECM_TEMP_VEH_LIST_VEHICLE_DESCRIPTION,
    this.ECM_TEMP_VEH_LIST_ALIAS,
    this.ECM_TEMP_VEH_LIST_IS_ASSIGNED,
  });

  factory TempVehicle.fromJson(Map<String, dynamic> json) {
    return TempVehicle(
      ECM_TEMP_VEH_LIST_VEHICLE_ID: json['ECM_TEMP_VEH_LIST_VEHICLE_ID'],
      ECM_TEMP_VEH_LIST_VEHICLE_DESCRIPTION: json['ECM_TEMP_VEH_LIST_VEHICLE_DESCRIPTION'],
      ECM_TEMP_VEH_LIST_ALIAS: json['ECM_TEMP_VEH_LIST_ALIAS'],
      ECM_TEMP_VEH_LIST_IS_ASSIGNED: json['ECM_TEMP_VEH_LIST_IS_ASSIGNED'],
    );
  }


  Map<String, dynamic> toMap() => {
    "ECM_TEMP_VEH_LIST_VEHICLE_ID": ECM_TEMP_VEH_LIST_VEHICLE_ID,
    "ECM_TEMP_VEH_LIST_VEHICLE_DESCRIPTION": ECM_TEMP_VEH_LIST_VEHICLE_DESCRIPTION,
    "ECM_TEMP_VEH_LIST_ALIAS": ECM_TEMP_VEH_LIST_ALIAS,
    "ECM_TEMP_VEH_LIST_IS_ASSIGNED":ECM_TEMP_VEH_LIST_IS_ASSIGNED,
  };
}