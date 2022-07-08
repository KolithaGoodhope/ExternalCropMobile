import 'package:external_crop/Bll/pendinglistbl.dart';
import 'package:external_crop/Objects/locationheader.dart';
import 'package:external_crop/Widget/question_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:external_crop/Widget/external_crop_detail_pop_up.dart';
import 'package:external_crop/Widget/base_alert_dialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class PendingListData extends DataTableSource {
  // Generate some made-up data
  final PendingListBL _pendingListBL = PendingListBL();
  List<LocationHeader> _data = [];
  BuildContext context;

  PendingListData(List<LocationHeader> value,BuildContext context){
    _data = value;
    this.context = context;
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
      DataCell(ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty
              .resolveWith<Color>(
                  (Set<MaterialState> states) {
                // return Color(0xffe6963e);
                    return Colors.orange;
              }),
          foregroundColor: MaterialStateProperty
              .resolveWith<Color>(
                  (Set<MaterialState> states) {
                return Colors.white;
              }),
        ),
        onPressed: () {
          if(_data[index].ECH_ID > 0)
          {
            _pendingListBL.getExternalCropDetailsByHeaderID(_data[index].ECH_ID).then((value) {
              if(value != null){
                if(value.length>0) {
                  DataTableSource _data = ExternalCropDetailPopUP(value);
                  _loadNewLocationList(context, _data);
                }else{
                  var baseDialog = BaseAlertDialog(
                    title: "Alert",
                    content: "No lines to view.",
                    yesOnPressed: () {
                      Navigator.pop(context);
                    },
                    yes: "OK",
                  );
                  showDialog(context: context, builder: (BuildContext context) => baseDialog);
                }
              }
              else
                {
                  var baseDialog = BaseAlertDialog(
                    title: "Alert",
                    content: "Network Connection Error.",
                    yesOnPressed: () {
                      Navigator.pop(context);
                    },
                    yes: "OK",
                  );
                  showDialog(context: context, builder: (BuildContext context) => baseDialog);
                }
            });
          }
        },
        child: Text('Show'),
      )),
      DataCell(ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty
              .resolveWith<Color>(
                  (Set<MaterialState> states) {
                return Colors.green;
              }),
          foregroundColor: MaterialStateProperty
              .resolveWith<Color>(
                  (Set<MaterialState> states) {
                return Colors.white;
              }),
        ),
        onPressed: () {
          if(_data[index].ECH_ID > 0)
          {
            var questionDialog = QuestionDialog(
                title: "Alert",
                content: "Are you sure you want to approve this?",
                yesOnPressed: () {
                  EasyLoading.show();
                  Navigator.pop(context);
                  _pendingListBL.approveECheader(_data[index].ECH_ID).then((value) {
                    EasyLoading.dismiss();
                    if(value =="1"){
                      _data.remove(_data[index]);
                      notifyListeners();
                      var baseDialog = BaseAlertDialog(
                        title: "Alert",
                        content: "Updated successfuly.",
                        yesOnPressed: () {Navigator.pop(context);},
                        yes: "OK",
                      );
                      showDialog(context: context, builder: (BuildContext context) => baseDialog);
                    }else{
                      var baseDialog = BaseAlertDialog(
                        title: "Alert",
                        content: "Error occurred. Please try again. ",
                        yesOnPressed: () {Navigator.pop(context);},
                        yes: "OK",
                      );
                      showDialog(context: context, builder: (BuildContext context) => baseDialog);
                    }
                  });
                },
                noOnPressed: () {
                  Navigator.pop(context);
                },
                yes: "Yes", no: "No"
            );
            showDialog(context: context,
                builder: (BuildContext context) => questionDialog);
          }
        },
        child: Text('Approve'),
      )),
      DataCell(ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty
              .resolveWith<Color>(
                  (Set<MaterialState> states) {
                return Colors.red;
              }),
          foregroundColor: MaterialStateProperty
              .resolveWith<Color>(
                  (Set<MaterialState> states) {
                return Colors.white;
              }),
        ),
        onPressed: () {
          if(_data[index].ECH_ID > 0)
          {
            var questionDialog = QuestionDialog(
                title: "Alert",
                content: "Are you sure you want to reject this?",
                yesOnPressed: () {
                  EasyLoading.show();
                  Navigator.pop(context);
                  _pendingListBL.rejectECheader(_data[index].ECH_ID).then((value) {
                    EasyLoading.dismiss();
                    if(value =="1"){
                      _data.remove(_data[index]);
                      notifyListeners();
                      var baseDialog = BaseAlertDialog(
                        title: "Alert",
                        content: "Updated successfuly.",
                        yesOnPressed: () {
                          Navigator.pop(context);
                          },
                        yes: "OK",
                      );
                      showDialog(context: context, builder: (BuildContext context) => baseDialog);
                    }else{
                      var baseDialog = BaseAlertDialog(
                        title: "Alert",
                        content: "Error occurred. Please try again. ",
                        yesOnPressed: () {Navigator.pop(context);},
                        yes: "OK",
                      );
                      showDialog(context: context, builder: (BuildContext context) => baseDialog);
                    }
                  });
                },
                noOnPressed: () {
                  Navigator.pop(context);
                },
                yes: "Yes", no: "No"
            );
            showDialog(context: context,
                builder: (BuildContext context) => questionDialog);
          }
        },
        child: Text('Reject'),
      )),
      DataCell(Text(_data[index].ECH_ID.toString())),
      DataCell(Text(new DateFormat("yyyy-MM-dd").format(_data[index].ECH_PURCHASE_DATE).toString())),
      DataCell(Text(_data[index].ECH_TOTAL_PURCHASED_QTY.toString())),
      DataCell(Text(_data[index].ECH_EXTERNAL_CROP_COST.toString())),
      DataCell(Text(_data[index].ECH_COST_AVG_PER_MT.toString())),
      DataCell(Text(_data[index].ECH_TOTAL_PENALTY_COST.toString())),
      DataCell(Text(_data[index].ECH_COST_AFTER_PENALTY.toString())),
    ]);
  }

  _loadNewLocationList(BuildContext context,DataTableSource _data){
    showDialog(
        context: context,
        builder: (context) {

          return StatefulBuilder( // StatefulBuilder
              builder: (context, setState)
              {
                return Dialog(
                  child: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Form(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            PaginatedDataTable(
                              source: _data,
                              columns: const [
                                DataColumn(label: Text('Mill Name')),
                                DataColumn(label: Text('Customer')),
                                DataColumn(label: Text('Purchased QTY (MT)')),
                                DataColumn(label: Text('Rate Per MT')),
                                DataColumn(label: Text('Penalty Perc')),
                                DataColumn(label: Text('Penalty Cost')),
                              ],
                              columnSpacing: 30,
                              horizontalMargin: 10,
                              rowsPerPage: 5,
                              showCheckboxColumn: false,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                            // return Color(0xffe6963e);
                                                return Colors.green;
                                          }),
                                      foregroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                            return Colors.white;
                                          }),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Close'),
                                  )
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });

        });
  }

}