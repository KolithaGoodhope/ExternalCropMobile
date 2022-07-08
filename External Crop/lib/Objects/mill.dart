class Mill{
  int LOC_ID = 0 ;
  String LOC_LOCATION_NAME ="";
  String LOC_CODE ="";
  String LOC_DESCRIPTION ="";

  Mill({
     this.LOC_ID,
     this.LOC_LOCATION_NAME,
     this.LOC_CODE,
     this.LOC_DESCRIPTION,
  });

  factory Mill.fromJson(Map<String, dynamic> json) {
    return Mill(
      LOC_ID: json['LOC_ID'],
      LOC_LOCATION_NAME: json['LOC_LOCATION_NAME'],
      LOC_CODE: json['LOC_LOCATION_NAME'],
      LOC_DESCRIPTION: json['LOC_DESCRIPTION'],
    );
  }


  Map<String, dynamic> toMap() => {
    "LOC_ID": LOC_ID,
    "LOC_LOCATION_NAME": LOC_LOCATION_NAME,
    "LOC_CODE": LOC_CODE,
    "LOC_DESCRIPTION": LOC_DESCRIPTION,
  };
}