import 'package:external_crop/Bll/pendinglistbl.dart';
import 'package:external_crop/Objects/ecmilldetail.dart';
import 'package:flutter/material.dart';

class PenaltyCostDetail extends DataTableSource {
  // Generate some made-up data
  final PendingListBL _pendingListBL = PendingListBL();
  List<ECMillDetail> _data = [];

  PenaltyCostDetail(List<ECMillDetail> value){
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
      DataCell(Text(_data[index].penaltyCost.toStringAsFixed(2))),
    ]);
  }
}