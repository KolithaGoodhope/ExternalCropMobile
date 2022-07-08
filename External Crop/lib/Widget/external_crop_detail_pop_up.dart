
import 'package:external_crop/Objects/ecmilldetail.dart';
import 'package:flutter/material.dart';
import 'package:external_crop/Objects/location.dart';

class ExternalCropDetailPopUP extends DataTableSource {
  // Generate some made-up data
  List<ECMillDetail> _data = [];

  ExternalCropDetailPopUP(List<ECMillDetail> value){
    _data = value;
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(_data[index].purchaseMillName.toString())),
      DataCell(Text(_data[index].supplierName.toString())),
      DataCell(Text(_data[index].pQty.toString())),
      DataCell(Text(_data[index].ratePerMT.toString())),
      DataCell(Text(_data[index].penaltyPerc.toString())),
      DataCell(Text(_data[index].penaltyCost.toString())),
    ]);
  }
}