class ECReportItem {
  String LOCATION_NAME ="";
  String DESCRIPTION="";
  double DAY_1_VALUE=0;
  double DAY_2_VALUE=0;
  double DAY_3_VALUE=0;
  double DAY_4_VALUE=0;
  double DAY_5_VALUE=0;
  double DAY_6_VALUE=0;
  double DAY_7_VALUE=0;
  double DAY_8_VALUE=0;
  double DAY_9_VALUE=0;
  double DAY_10_VALUE=0;
  double DAY_11_VALUE=0;
  double DAY_12_VALUE=0;
  double DAY_13_VALUE=0;
  double DAY_14_VALUE=0;
  double DAY_15_VALUE=0;
  double DAY_16_VALUE=0;
  double DAY_17_VALUE=0;
  double DAY_18_VALUE=0;
  double DAY_19_VALUE=0;
  double DAY_20_VALUE=0;
  double DAY_21_VALUE=0;
  double DAY_22_VALUE=0;
  double DAY_23_VALUE=0;
  double DAY_24_VALUE=0;
  double DAY_25_VALUE=0;
  double DAY_26_VALUE=0;
  double DAY_27_VALUE=0;
  double DAY_28_VALUE=0;
  double DAY_29_VALUE=0;
  double DAY_30_VALUE=0;
  double DAY_31_VALUE=0;

  ECReportItem({
     this.LOCATION_NAME,
     this.DESCRIPTION,
     this.DAY_1_VALUE, this.DAY_2_VALUE, this.DAY_3_VALUE, this.DAY_4_VALUE, this.DAY_5_VALUE, this.DAY_6_VALUE, this.DAY_7_VALUE, this.DAY_8_VALUE, this.DAY_9_VALUE, this.DAY_10_VALUE,
     this.DAY_11_VALUE, this.DAY_12_VALUE, this.DAY_13_VALUE, this.DAY_14_VALUE, this.DAY_15_VALUE, this.DAY_16_VALUE, this.DAY_17_VALUE, this.DAY_18_VALUE, this.DAY_19_VALUE, this.DAY_20_VALUE,
     this.DAY_21_VALUE, this.DAY_22_VALUE, this.DAY_23_VALUE, this.DAY_24_VALUE, this.DAY_25_VALUE, this.DAY_26_VALUE, this.DAY_27_VALUE, this.DAY_28_VALUE, this.DAY_29_VALUE, this.DAY_30_VALUE,
     this.DAY_31_VALUE});

  factory ECReportItem.fromJson(Map<String, dynamic> json) {
    return ECReportItem(
      LOCATION_NAME: json['LOCATION_NAME'] as String,
      DESCRIPTION: json['DESCRIPTION'] as String,
      DAY_1_VALUE: json['DAY_1_VALUE'] as double,DAY_2_VALUE: json['DAY_2_VALUE'] as double,DAY_3_VALUE: json['DAY_3_VALUE'] as double,DAY_4_VALUE: json['DAY_4_VALUE'] as double,DAY_5_VALUE: json['DAY_5_VALUE'] as double,DAY_6_VALUE: json['DAY_6_VALUE'] as double,DAY_7_VALUE: json['DAY_7_VALUE'] as double,DAY_8_VALUE: json['DAY_8_VALUE'] as double,DAY_9_VALUE: json['DAY_9_VALUE'] as double,DAY_10_VALUE: json['DAY_10_VALUE'] as double,
      DAY_11_VALUE: json['DAY_11_VALUE'] as double,DAY_12_VALUE: json['DAY_12_VALUE'] as double,DAY_13_VALUE: json['DAY_13_VALUE'] as double,DAY_14_VALUE: json['DAY_14_VALUE'] as double,DAY_15_VALUE: json['DAY_15_VALUE'] as double,DAY_16_VALUE: json['DAY_16_VALUE'] as double,DAY_17_VALUE: json['DAY_17_VALUE'] as double,DAY_18_VALUE: json['DAY_18_VALUE'] as double,DAY_19_VALUE: json['DAY_19_VALUE'] as double,DAY_20_VALUE: json['DAY_20_VALUE'] as double,
      DAY_21_VALUE: json['DAY_12_VALUE'] as double,DAY_22_VALUE: json['DAY_22_VALUE'] as double,DAY_23_VALUE: json['DAY_23_VALUE'] as double,DAY_24_VALUE: json['DAY_24_VALUE'] as double,DAY_25_VALUE: json['DAY_25_VALUE'] as double,DAY_26_VALUE: json['DAY_26_VALUE'] as double,DAY_27_VALUE: json['DAY_27_VALUE'] as double,DAY_28_VALUE: json['DAY_28_VALUE'] as double,DAY_29_VALUE: json['DAY_29_VALUE'] as double,DAY_30_VALUE: json['DAY_30_VALUE'] as double,
      DAY_31_VALUE: json['DAY_31_VALUE'] as double);
  }
}