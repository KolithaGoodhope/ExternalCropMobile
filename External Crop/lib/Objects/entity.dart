class Entity{
  int ECM_ENTITY_ID = 0 ;
  String ECM_ENTITY_DESCRIPTION ="";
  String ECM_ALIAS ="";
  int ECM_ENTITY_REF_ID = 0 ;
  int ECM_ENTITY_REF_PARENT_ID = 0 ;
  int ECM_ENTITY_TYPE = 0 ;

  Entity({
     this.ECM_ENTITY_ID,
     this.ECM_ENTITY_DESCRIPTION,
     this.ECM_ALIAS,
     this.ECM_ENTITY_REF_ID,
     this.ECM_ENTITY_REF_PARENT_ID,
     this.ECM_ENTITY_TYPE,
  });

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      ECM_ENTITY_ID: json['ECM_ENTITY_ID'],
      ECM_ENTITY_DESCRIPTION: json['ECM_ENTITY_DESCRIPTION'],
      ECM_ALIAS: json['ECM_ALIAS'],
      ECM_ENTITY_REF_ID: json['ECM_ENTITY_REF_ID'],
      ECM_ENTITY_REF_PARENT_ID: json['ECM_ENTITY_REF_PARENT_ID'],
      ECM_ENTITY_TYPE: json['ECM_ENTITY_TYPE'],
    );
  }


  Map<String, dynamic> toMap() => {
    "ECM_ENTITY_ID": ECM_ENTITY_ID,
    "ECM_ENTITY_DESCRIPTION": ECM_ENTITY_DESCRIPTION,
    "ECM_ALIAS": ECM_ALIAS,
    "ECM_ENTITY_REF_ID": ECM_ENTITY_REF_ID,
    "ECM_ENTITY_REF_PARENT_ID": ECM_ENTITY_REF_PARENT_ID,
    "ECM_ENTITY_TYPE": ECM_ENTITY_TYPE,
  };
}