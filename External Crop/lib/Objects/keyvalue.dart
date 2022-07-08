class KeyValue{

  int ECM_VAL_ID = 0 ;
  String ECM_VAL_KEY ="";
  String ECM_VAL_VALUE ="";
  String ECM_VAL_DESCRIPTION ="";
  int ECM_VAL_ACTIVE = 0 ;
  String ECM_VAL_VALUE_2 ="";

  KeyValue({
    this.ECM_VAL_ID,
    this.ECM_VAL_KEY,
    this.ECM_VAL_VALUE,
    this.ECM_VAL_DESCRIPTION,
    this.ECM_VAL_ACTIVE,
    this.ECM_VAL_VALUE_2,
  });

  factory KeyValue.fromJson(Map<String, dynamic> json) {
    return KeyValue(
      ECM_VAL_ID: json['ECM_VAL_ID'],
      ECM_VAL_KEY: json['ECM_VAL_KEY'],
      ECM_VAL_VALUE: json['ECM_VAL_VALUE'],
      ECM_VAL_DESCRIPTION: json['ECM_VAL_DESCRIPTION'],
      ECM_VAL_ACTIVE: json['ECM_VAL_ACTIVE'],
      ECM_VAL_VALUE_2: json['ECM_VAL_VALUE_2'],
    );
  }


  Map<String, dynamic> toMap() => {
    "ECM_VAL_ID": ECM_VAL_ID,
    "ECM_VAL_KEY": ECM_VAL_KEY,
    "ECM_VAL_VALUE": ECM_VAL_VALUE,
    "ECM_VAL_DESCRIPTION": ECM_VAL_DESCRIPTION,
    "ECM_VAL_ACTIVE": ECM_VAL_ACTIVE,
    "ECM_VAL_VALUE_2": ECM_VAL_VALUE_2,
  };
}