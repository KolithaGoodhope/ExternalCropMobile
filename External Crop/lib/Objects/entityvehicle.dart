class EntityVehicleMap{
  int ECM_ENT_VEH_MAP_ID = 0 ;
  int ECM_ENT_VEH_MAP_ENTITY_REF_ID =0;
  int ECM_ENT_VEH_MAP_VEHICLE_REF_ID =0;


  EntityVehicleMap({
     this.ECM_ENT_VEH_MAP_ID,
     this.ECM_ENT_VEH_MAP_ENTITY_REF_ID,
     this.ECM_ENT_VEH_MAP_VEHICLE_REF_ID,
  });

  factory EntityVehicleMap.fromJson(Map<String, dynamic> json) {
    return EntityVehicleMap(
      ECM_ENT_VEH_MAP_ID: json['ECM_ENT_VEH_MAP_ID'],
      ECM_ENT_VEH_MAP_ENTITY_REF_ID: json['ECM_ENT_VEH_MAP_ENTITY_REF_ID'],
      ECM_ENT_VEH_MAP_VEHICLE_REF_ID: json['ECM_ENT_VEH_MAP_VEHICLE_REF_ID'],
    );
  }


  Map<String, dynamic> toMap() => {
    "ECM_ENT_VEH_MAP_ID": ECM_ENT_VEH_MAP_ID,
    "ECM_ENT_VEH_MAP_ENTITY_ID": ECM_ENT_VEH_MAP_ENTITY_REF_ID,
    "ECM_ENT_VEH_MAP_VEHICLE_ID": ECM_ENT_VEH_MAP_VEHICLE_REF_ID,
  };
}