class ExternalCropOb{
  double totalPurchasedQTY =0.0;
  double incentivePerMT = 0.0 ;
  double incentiveTotal = 0.0;
  double externalCropCost = 0.0;
  double costAveragePerMT = 0.0;
  double totalPenaltyCost = 0.0;
  double externalCropCostAfterPenalty = 0.0;

  ExternalCropOb({
     this.totalPurchasedQTY,
     this.incentivePerMT,
     this.incentiveTotal,
     this.externalCropCost,
     this.costAveragePerMT,
     this.totalPenaltyCost,
     this.externalCropCostAfterPenalty
  });

  factory ExternalCropOb.fromJson(Map<String, dynamic> json) {
    return ExternalCropOb(
        totalPurchasedQTY: json['title'],
        incentivePerMT: json['title'],
        incentiveTotal: json['title'],
        externalCropCost: json['title'],
        costAveragePerMT: json['title'],
        totalPenaltyCost: json['title'],
        externalCropCostAfterPenalty: json['title'],
    );
  }

  Map<String, dynamic> toMap() => {
    "totalPurchasedQTY": totalPurchasedQTY,
    "incentivePerMT": incentivePerMT,
    "incentiveTotal": incentiveTotal,
    "externalCropCost": externalCropCost,
    "costAveragePerMT": costAveragePerMT,
    "totalPenaltyCost": totalPenaltyCost,
    "externalCropCostAfterPenalty": externalCropCostAfterPenalty,
  };
 }