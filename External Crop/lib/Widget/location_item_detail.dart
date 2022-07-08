import 'package:external_crop/Bll/externalcropbl.dart';
import 'package:external_crop/Objects/ecmilldetail.dart';
import 'package:external_crop/Objects/locationheader.dart';
import 'package:external_crop/Utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocationItemDetail  extends DataTableSource {
  // Generate some made-up data
  ExternalCropBL _externalCropBL = ExternalCropBL();
  BuildContext _context;
  List<ECMillDetail> _data = [];
  LocationHeader _locationHeader = LocationHeader(ECH_ID: 0, ECH_PURCHASED_ID: "", ECH_INCENTIVE_PER_MT: 0, ECH_TOTAL_PURCHASED_QTY: 0, ECH_INCENTIVE: 0, ECH_EXTERNAL_CROP_COST: 0, ECH_COST_AVG_PER_MT: 0, ECH_TOTAL_PENALTY_COST: 0, ECH_COST_AFTER_PENALTY: 0, ECH_CONFIRMED: 0, ecMillDetailList: [], ECH_PURCHASE_DATE: DateTime.now(), isUpdate: false);


  LocationItemDetail(List<ECMillDetail> value,LocationHeader lcHeader,BuildContext _con){
    _data = value;
    _locationHeader = lcHeader;
    _context = _con;
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
      DataCell(TextFormField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0)
          ),
        ),
        keyboardType: TextInputType.number,
//        inputFormatters: [WhitelistingTextInputFormatter(RegExp(r'^\d+\.?\d{0,2}'))],
        inputFormatters: [Validation()],
        initialValue: _data[index].ratePerMT== 0? "":_data[index].ratePerMT.toStringAsFixed(2),
        onTap: () async {
        },
        onChanged: (text) {
          _data[index].ratePerMT = text.trim() == "" ? 0 : double.parse(text);
          _calculateLocationPenaltyCost(_data[index]);
          _locationHeader.isUpdate = false;
          notifyListeners();
        },
      ),),
      DataCell(TextFormField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0)
          ),
        ),
        keyboardType: TextInputType.number,
//        inputFormatters: [WhitelistingTextInputFormatter(RegExp(r'^\d+\.?\d{0,2}'))],
        inputFormatters: [Validation()],
        initialValue: _data[index].penaltyPerc== 0? "":_data[index].penaltyPerc.toStringAsFixed(2),
        onTap: () async {
        },
        onChanged: (text) {
          _data[index].penaltyPerc = text.trim() == ""? 0.0:double.parse(text.toString());
          _calculateLocationPenaltyCost(_data[index]);
          _locationHeader.isUpdate = false;
          notifyListeners();
        },
      ),),
    ]);
  }

  _calculateLocationPenaltyCost(ECMillDetail location){
      location.penaltyCost = _externalCropBL.calculateLocationPenaltyCostByLocation(location);
  }
}