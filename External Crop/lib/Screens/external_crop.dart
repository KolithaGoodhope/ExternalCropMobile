import 'dart:convert';
import 'package:external_crop/Bll/externalcropbl.dart';
import 'package:external_crop/Objects/ecmilldetail.dart';
import 'package:external_crop/Objects/mill.dart';
import 'package:external_crop/Utils/validation.dart';
import 'package:external_crop/Widget/question_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:external_crop/Objects/locationheader.dart';
import 'package:external_crop/Widget/external_crop_data_add_header.dart';
import 'package:external_crop/Widget/base_alert_dialog.dart';
import 'package:external_crop/Objects/externalcrop.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:external_crop/Widget/penalty_cost_detail.dart';
import 'package:external_crop/Widget/location_item_detail.dart';


class ExternalCrop extends StatefulWidget {
  @override
  _ExternalCrop createState() => _ExternalCrop();
}

class _ExternalCrop extends State<ExternalCrop> {
  TextEditingController _dateinput = TextEditingController();
//  GlobalKey<FormState> _key = new GlobalKey();
  List<ECMillDetail> _ecMillDetailList = [];
  List<Mill> _allMills = [];
  List<Mill> _selectedMills = [];
  List<Mill> _removedMills = [];
  LocationHeader _currentLocationHeader = LocationHeader(ECH_ID: 0, ECH_PURCHASED_ID: "", ECH_INCENTIVE_PER_MT: 0, ECH_TOTAL_PURCHASED_QTY: 0, ECH_INCENTIVE: 0, ECH_EXTERNAL_CROP_COST: 0, ECH_COST_AVG_PER_MT: 0, ECH_TOTAL_PENALTY_COST: 0, ECH_COST_AFTER_PENALTY: 0, ECH_CONFIRMED: 0, ecMillDetailList: [], ECH_PURCHASE_DATE: DateTime.now(), isUpdate: false);
//  bool _sort = false;
  DataTableSource _dataSummary;
  DataTableSource _dataECMillDetail;

  bool _showAddECMillDetail = false;
  bool _isSaveButtonPressed = false;
  bool _isSaveBottonEnabled = true;
  TextEditingController _incentivePerMT = TextEditingController();
  ExternalCropBL _externalCropBL = ExternalCropBL();

  String _totalPurchasedQTY = "";
  String _incentiveTotal = "";
  String _totalExternalCropCost = "";
  String _costAveragePerMT = "";
  String _totalPenaltyCost = "";
  String _totalExternalCropCostAfterPenalty = "";
  List<ECMillDetail> _dataSummaryArray = [];
  List<ECMillDetail> _dataECMillDetailArray = [];


  @override
  void initState() {
    _dateinput.text = ""; //set the initial value of text field
//    _sort = false;
    _dataSummary = PenaltyCostDetail(_dataSummaryArray);
    _dataECMillDetail = LocationItemDetail(_dataECMillDetailArray,_currentLocationHeader,context);
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return new WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
            body: Stack
            (
              children:
              [
                ExternalCropHeader(),
                FormUI(context),
              ],
            ),
          ),
        );
  }


  Widget FormUI(BuildContext context) {

    double pageheight = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double totalverPad = statusBarHeight + (pageheight * 0.15) ;

    return SafeArea(
      child :Container(
        child:Padding(
          padding: EdgeInsets.fromLTRB(10.0, totalverPad, 10.0, 10.0),
          child: ListView(
            children: <Widget>[

              Material(
                shadowColor: Colors.white.withOpacity(0.01), // added
                type: MaterialType.card,
                elevation: 10, borderRadius: new BorderRadius.circular(15.0),
                child : Container(
                  margin: EdgeInsets.all(5),
                  color: Colors.white,

                  child: Table(
                    border: TableBorder.symmetric(inside: BorderSide(color: Colors.white70) ),
                    columnWidths: {
                      0: FlexColumnWidth(8),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(3),
                    },
                    children: [
                      TableRow(
                          children: [
                            SizedBox(
                              child : TextFormField(
                                controller: _dateinput,
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: 'Select a Date',
                                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),
                                ),
                                onTap: () async {
                                  setState(() {
                                    _currentLocationHeader.isUpdate = false;
                                    _showAddECMillDetail = false;
                                  });
                                  DateTime pickedDate = await showDatePicker(
                                      context: context,
                                      builder: (BuildContext context, Widget child) {
                                        return Theme(
                                          data: ThemeData(
                                            primarySwatch: Colors.grey,
                                            splashColor: Colors.black,
                                            textTheme: TextTheme(
                                              subtitle1: TextStyle(color: Colors.black),
                                              button: TextStyle(color: Colors.black),
                                            ),
                                            accentColor: Colors.black,
                                            colorScheme: ColorScheme.light(
//                                                primary: Color(0xffffbc00),
                                                primary: Colors.green.shade400,
                                                primaryVariant: Colors.black,
                                                secondaryVariant: Colors.black,
                                                onSecondary: Colors.black,
                                                onPrimary: Colors.white,
                                                surface: Colors.black,
                                                onSurface: Colors.black,
                                                secondary: Colors.black),
                                            dialogBackgroundColor: Colors.white,
                                          ),
                                          child: child ??Text(""),
                                        );
                                      },
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(DateTime.now().year - 10), //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime.now()
                                  );

                                  if(pickedDate != null ){
                                    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                    setState(() {
                                      _dateinput.text = formattedDate;
                                    });
                                  }else{
                                    print("Date is not selected");
                                  }
                                },
                              ),
                            ),

                            SizedBox(width: 10),
                            SizedBox(
                                child : ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                          //return Color(0xffe6963e);
                                            return Colors.green;
                                        }),
                                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                          return Colors.white;
                                        }),
                                  ),
                                  onPressed: () {

                                    _refreshLocationDataGrid();
                                  },
                                  child: Text('Search'),
                                )
                            ),
                          ]),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),

              Visibility(
                visible: _showAddECMillDetail,
                child: Material(
                  shadowColor: Colors.white.withOpacity(0.01), // added

                  type: MaterialType.card,
                  elevation: 10, borderRadius: new BorderRadius.circular(10.0),

                  child: Column(
                      children: [
                        Container(margin: EdgeInsets.all(10),
                          color: Colors.white,

                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "External Crop Details:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              SizedBox(
                                height: 10,
                              ),
/*
                              SizedBox(
                                  child : ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                                              (Set<MaterialState> states) {
                                            return Color(0xffe6963e);
                                          }),
                                      foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                                              (Set<MaterialState> states) {
                                            return Colors.white;
                                          }),
                                    ),
                                    onPressed: (){
                                      EasyLoading.show();
                                      _loadLocationList().then((locationList){
                                        if(locationList!= null) {
                                          _loadNewLocationList(context);
                                        }
                                        EasyLoading.dismiss();
                                      });

                                    },
                                    child: Text('Add New Location'),
                                  )
                              ),
*/
                              SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: PaginatedDataTable(
                                  source: _dataECMillDetail,
                                  columns: const [
                                    DataColumn(label: Text('Mill')),
                                    DataColumn(label: Text('Customer')),
                                    DataColumn(label: Text('Purchased QTY (MT)')),
                                    DataColumn(label: Text('Rate Per MT')),
                                    DataColumn(label: Text('Penalty Percentage')),
                                  ],
                                  columnSpacing: 70,
                                  horizontalMargin: 10,
                                  rowsPerPage: 5,
                                  showCheckboxColumn: false,
                                ),

                              ),
                            ],
                          ),
                        ),
                        Container(margin: EdgeInsets.all(10),
                          color: Colors.white,
                          child: Table(
                            border: TableBorder.symmetric(inside: BorderSide(color: Colors.white70) ),columnWidths: {
                            0: FlexColumnWidth(3),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(8),
                          },
                            children: [
                              TableRow(
                                  children: [
                                    SizedBox(
                                      child : Text("Incentive Per  MT :"),
                                    ),

                                    SizedBox(width: 5),
                                    //                    SizedBox(
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      child : TextFormField(
                                        controller: _incentivePerMT,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0)
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [Validation()],
                                        onTap: () async {

                                        },
                                        onChanged: (text) {
                                           setState(() {
                                              _currentLocationHeader.isUpdate = false;
                                           });
                                         },
                                      ),
                                    ),
                                    //                   ),
                                  ]),
                            ],
                          ),
                        ),
                        Container(margin: EdgeInsets.all(10),
                          color: Colors.white,
                          child: Table(
                            border: TableBorder.symmetric(inside: BorderSide(color: Colors.white70) ),columnWidths: {
                            0: FixedColumnWidth(MediaQuery.of(context).size.width*0.4),
                            1: FlexColumnWidth(MediaQuery.of(context).size.width*0.1),
                            2: FlexColumnWidth(MediaQuery.of(context).size.width*0.4),
                          },
                            children: [
                              TableRow(
                                  children: [
                                    SizedBox(
                                        child : ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                                    (Set<MaterialState> states) {
                                                  // return Color(0xffe6963e);
                                                      return Colors.green;
                                                }),
                                            foregroundColor: MaterialStateProperty.resolveWith<Color>(
                                                    (Set<MaterialState> states) {
                                                  return Colors.white;
                                                }),
                                          ),
                                          onPressed: () {
                                            double totQty = 0;
                                            for(var x = 0;x<_ecMillDetailList.length;x++)
                                            {
                        //                      if(_ecMillDetailList[x].ratePerMT > 0) {
                                                totQty = totQty + _ecMillDetailList[x].pQty;
                        //                      }
                                            }
                                            if(_ecMillDetailList.isNotEmpty && totQty > 0){
                                              ExternalCropOb externalCrop = _externalCropBL.getExternalCropSummary(_ecMillDetailList,_incentivePerMT.text) ;
                                              setState(() {
                                              _totalPurchasedQTY = externalCrop.totalPurchasedQTY.toStringAsFixed(0);
                                              _incentiveTotal = externalCrop.incentiveTotal.toStringAsFixed(2);
                                              _totalExternalCropCost = externalCrop.externalCropCost.toStringAsFixed(2);
                                              _costAveragePerMT = externalCrop.costAveragePerMT.toStringAsFixed(2);
                                              _totalPenaltyCost = externalCrop.totalPenaltyCost.toStringAsFixed(2);
                                              _totalExternalCropCostAfterPenalty = externalCrop.externalCropCostAfterPenalty.toStringAsFixed(2);

                                              _currentLocationHeader.ECH_TOTAL_PURCHASED_QTY = externalCrop.totalPurchasedQTY.toInt();
                                              _currentLocationHeader.ECH_INCENTIVE = externalCrop.incentiveTotal;
                                              _currentLocationHeader.ECH_EXTERNAL_CROP_COST = externalCrop.externalCropCost;
                                              _currentLocationHeader.ECH_COST_AVG_PER_MT = externalCrop.costAveragePerMT;
                                              _currentLocationHeader.ECH_TOTAL_PENALTY_COST = externalCrop.totalPenaltyCost;
                                              _currentLocationHeader.ECH_COST_AFTER_PENALTY = externalCrop.externalCropCostAfterPenalty;
                                              _currentLocationHeader.ECH_INCENTIVE_PER_MT = externalCrop.incentivePerMT;

                                              _dataSummary = PenaltyCostDetail(_ecMillDetailList);
                                              _currentLocationHeader.isUpdate = true;
                                              });
                                            }
                                            else
                                            {
                                                var baseDialog = BaseAlertDialog(
                                                title: "Alert",
                                                content: "No location data to calculate.",
                                                yesOnPressed: () {Navigator.pop(context);},
                                                yes: "OK",
                                              );
                                              showDialog(context: context, builder: (BuildContext context) => baseDialog);
                                            }
                                          },
                                          child: Text('Calculate'),
                                        )
                                    ),

                                    SizedBox(width: 5),
                                    //                    SizedBox(
                                    SizedBox(
                                        child : ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                                    (Set<MaterialState> states) {
                                                  // return Color(0xffe6963e);
                                                      return Colors.green;
                                                }),
                                            foregroundColor: MaterialStateProperty.resolveWith<Color>(
                                                    (Set<MaterialState> states) {
                                                  return Colors.white;
                                                }),
                                          ),
                                          onPressed: _externalCropDetailsClear,
                                          child: Text('Clear'),
                                        )
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
              SizedBox(height: 5),

              Visibility(
                visible: _currentLocationHeader.isUpdate,
                child:Material(
                  shadowColor: Colors.white.withOpacity(0.01), // added
                  type: MaterialType.card,
                  elevation: 10, borderRadius: new BorderRadius.circular(10.0),

                  child: Column(
                      children: [
                        Container(margin: EdgeInsets.all(10),
                          color: Colors.white,

                          child: Table(
                            border: TableBorder.symmetric(inside: BorderSide(color: Colors.white,width: 0.0),
                                outside:BorderSide(width: 0.0, color: Colors.white)  ),columnWidths: {
                            0: FixedColumnWidth(MediaQuery.of(context).size.width*0.4),
                            1: FixedColumnWidth(MediaQuery.of(context).size.width*0.1),
                            2: FixedColumnWidth(MediaQuery.of(context).size.width*0.3),
                          },
                            children: [
                              TableRow(
                                  children: [
                                    SizedBox(
                                      child : Text("Total Purchased QTY") , //Text("Total Purchased QTY:"),
                                    ), //
                                    SizedBox(
                                      child : Text(":") , //Text("Total Purchased QTY:"),
                                    ),
                                    Container(
                                      child : Text(_totalPurchasedQTY),
                                    ),
                                    //                   ),
                                  ]),
                              TableRow(
                                  children: [
                                    SizedBox(
                                      child : Text("Incentive"),
                                    ),
                                    SizedBox(
                                      child : Text(":") , //Text("Total Purchased QTY:"),
                                    ),
                                    Container(
                                      child : Text(_incentiveTotal),
                                    ),
                                    //                   ),
                                  ]),
                              TableRow(
                                  children: [
                                    SizedBox(
                                      child : Text("External Crop Cost:"),
                                    ),
                                    SizedBox(
                                      child : Text(":") , //Text("Total Purchased QTY:"),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      child : Text(_totalExternalCropCost),
                                    ),
                                    //                   ),
                                  ]),
                              TableRow(
                                  children: [
                                    SizedBox(
                                      child : Text("Cost Average Per MT:"),
                                    ),
                                    SizedBox(
                                      child : Text(":") , //Text("Total Purchased QTY:"),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      child : Text(_costAveragePerMT),
                                    ),
                                    //                   ),
                                  ]),
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
              SizedBox(height: 5),

              Visibility(
                visible: _currentLocationHeader.isUpdate,
                child:Material(
                  shadowColor: Colors.white.withOpacity(0.01), // added
                  type: MaterialType.card,
                  elevation: 10, borderRadius: new BorderRadius.circular(10.0),

                  child: Column(
                      children: [
                        Container(margin: EdgeInsets.all(10),alignment: Alignment.topLeft,color: Colors.white,
                          child: Text('Penalty Costs:',style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                        ),

                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          /*
                            child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowColor:MaterialStateProperty.all<Color>(Colors.black26.withOpacity(0.1)) ,
                              sortAscending: _sort,
                              sortColumnIndex: 0,
                              showBottomBorder: true,
                              dividerThickness: 5.0,
                              headingRowHeight: 50.0,
                              dataRowHeight: 50.0,
                              columns: [

                                DataColumn(label: Container(
                                  child: Center(
                                    child: Text(
                                      'Purchase Location',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),

                                ),
                                DataColumn(label: Container(
                                  child: Center(
                                    child: Text(
                                      '',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),),
                                DataColumn(label: Container(
                                  width: 135,
                                  child: Center(
                                    child: Text(
                                      'Penalty Cost',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),),
                              ],
                              rows:
                              _ecMillDetailList.map(
                                    (location) => DataRow(
                                    cells: [
                                      DataCell(
                                        Text(location.purchaseLocation),
                                      ),
                                      DataCell(VerticalDivider(width: 1.0,thickness: 5.0)),
                                      DataCell(
                                        Text(location.penaltyCost.toStringAsFixed(2)),
                                      ),
                                    ]),
                              ).toList(),
                            ),
                          ),
                          */
                            child: PaginatedDataTable(
                              source: _dataSummary,
                              columns: const [
                                DataColumn(label: Text('Mill')),
                                DataColumn(label: Text('Customer')),
                                DataColumn(label: Text('Penalty Cost')),
                              ],
                              columnSpacing: 70,
                              horizontalMargin: 10,
                              rowsPerPage: 5,
                              showCheckboxColumn: false,
                            ),


                        ),
                        Container(margin: EdgeInsets.all(10),
                          color: Colors.white,

                          child: Table(
                            border: TableBorder.symmetric(inside: BorderSide(color: Colors.white,width: 0.0),
                                outside:BorderSide(width: 0.0, color: Colors.white)  ),columnWidths: {
                            0: FlexColumnWidth(4),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(5),
                          },
                            children: [
                              TableRow(
                                  children: [
                                    SizedBox(
                                      child : Text("Total Penalty Cost"),
                                    ), //                    SizedBox(
                                    SizedBox(
                                      child : Text(":"),
                                    ), //
                                    Container(
                                      child : Text(_totalPenaltyCost),
                                    ),
                                    //                   ),
                                  ]),
                              TableRow(
                                  children: [
                                    SizedBox(
                                      child : Text("External Crop Cost After Penalty"),
                                    ),
                                    SizedBox(
                                      child : Text(":"),
                                    ),
                                    Container(
                                      child : Text(_totalExternalCropCostAfterPenalty),
                                    ),
                                    //                   ),
                                  ]),
                            ],
                          ),
                        ),
                        Container(margin: EdgeInsets.all(10),
                          color: Colors.white,
                          child: Table(
                            border: TableBorder.symmetric(inside: BorderSide(color: Colors.white70) ),columnWidths: {
                            0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.28),
                            1: FixedColumnWidth(MediaQuery.of(context).size.width * 0.035),
                            2: FixedColumnWidth(MediaQuery.of(context).size.width * 0.28),
                            3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.035),
                            4: FixedColumnWidth(MediaQuery.of(context).size.width * 0.28),
                            5: FixedColumnWidth(MediaQuery.of(context).size.width * 0.035),
                          },
                            children: [
                              TableRow(
                                  children: [
                                    SizedBox(
                                        child : ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                                    (Set<MaterialState> states) {
                                               //   return Color(0xffe6963e);
                                                      return Colors.green;
                                                }),
                                            foregroundColor: MaterialStateProperty.resolveWith<Color>(
                                                    (Set<MaterialState> states) {
                                                  return Colors.white;
                                                }),
                                          ),
                                          onPressed: _isSaveBottonEnabled == true? _SaveLocationData: _unableToEdit,
                                          child: Text('Save'),
                                        )
                                    ),

                                    SizedBox(),
                                    SizedBox(
                                        child : ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                                    (Set<MaterialState> states) {
                           //                       return Color(0xffe6963e);
                                                      return Colors.green;
                                                }),
                                            foregroundColor: MaterialStateProperty.resolveWith<Color>(
                                                    (Set<MaterialState> states) {
                                                  return Colors.white;
                                                }),
                                          ),
                                          onPressed: _clearButtonPress,
                                          child: Text('Clear'),
                                        )
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
              SizedBox(height: 5),

            ],
          ),
        ),
      ),
    );
  }

  _refreshLocationDataGrid() async {
    EasyLoading.show();
    if(!_dateinput.text.isEmpty ) {
      setState(() {
        _ecMillDetailList.clear();
        _selectedMills.clear();
        _removedMills.clear();
        _incentivePerMT.text = "";
        _showAddECMillDetail = false;
        _currentLocationHeader.isUpdate = false;
      });

      _externalCropBL.getLocationDetailsByDate(DateTime.parse(_dateinput.text)).then((value) {
        if(value == null)
        {
          EasyLoading.dismiss();
          var baseDialog = BaseAlertDialog(
            title: "Alert",
            content: "Network Connection Error.",
            yesOnPressed: () {Navigator.pop(context);},
            yes: "OK",
          );
          showDialog(context: context, builder: (BuildContext context) => baseDialog);
        }
        else
        {
          EasyLoading.dismiss();
          if(value.ECH_ID == -1){
            var baseDialog = BaseAlertDialog(
              title: "Alert",
              content: "No Data to show.",
              yesOnPressed: () {Navigator.pop(context);},
              yes: "OK",
            );
            showDialog(context: context, builder: (BuildContext context) => baseDialog);
          }
          else{
            EasyLoading.dismiss();
            _currentLocationHeader = value;
            _currentLocationHeader.ECH_PURCHASE_DATE =
                DateTime.parse(_dateinput.text);
            setState(() {
              _ecMillDetailList = _currentLocationHeader.ecMillDetailList;
              _dataECMillDetail = LocationItemDetail(_ecMillDetailList,_currentLocationHeader,context);
              _incentivePerMT.text =
                  _currentLocationHeader.ECH_INCENTIVE_PER_MT.toStringAsFixed(2);
              _totalPurchasedQTY =
                  _currentLocationHeader.ECH_TOTAL_PURCHASED_QTY.toStringAsFixed(3);
              _incentiveTotal =
                  _currentLocationHeader.ECH_INCENTIVE.toStringAsFixed(2);
              _totalExternalCropCost =
                  _currentLocationHeader.ECH_EXTERNAL_CROP_COST.toStringAsFixed(2);
              _costAveragePerMT =
                  _currentLocationHeader.ECH_COST_AVG_PER_MT.toStringAsFixed(2);
              _totalPenaltyCost =
                  _currentLocationHeader.ECH_TOTAL_PENALTY_COST.toStringAsFixed(2);
              _totalExternalCropCostAfterPenalty =
                  _currentLocationHeader.ECH_COST_AFTER_PENALTY.toStringAsFixed(2);
              _showAddECMillDetail = true;
              if(_currentLocationHeader.ECH_CONFIRMED == 1){
                _isSaveBottonEnabled = false;
              }
              else{
                _isSaveBottonEnabled = true;
              }
            });
          }
        }
      });
 //     EasyLoading.dismiss();
    }
    else
    {
      EasyLoading.dismiss();
      var baseDialog = BaseAlertDialog(
        title: "Alert",
        content: "Please select a date",
        yesOnPressed: () {Navigator.pop(context);},
        yes: "OK",
      );
      showDialog(context: context, builder: (BuildContext context) => baseDialog);
    }
  }

/*
  _calculateLocationPenaltyCost(Location location){
    setState(() {
      location.penaltyCost = _externalCropBL.calculateLocationPenaltyCostByLocation(location);
      _showExternalCropSummaryDetails = false;
      _showPenaltyCostDetails = false;
    });
  }
*/

  _externalCropDetailsClear(){

    var questionDialog = QuestionDialog(
      title: "Alert",
      content: "Are you sure you want to clear all? ",
      yesOnPressed: () {
        _dateinput.text="";
        setState(() {
          _showAddECMillDetail = false;
          _currentLocationHeader.isUpdate = false;
        });
        Navigator.pop(context);
      },
      noOnPressed: () {
        Navigator.pop(context);
        },
    );
    showDialog(context: context, builder: (BuildContext context) => questionDialog);

  }

  _clearButtonPress()
  {
    setState(() {
      _currentLocationHeader.isUpdate = false;
    });
  }

  _loadNewLocationList(context){
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
                        ListView(
                          padding: EdgeInsets.all(8.0),
                          shrinkWrap: true,
                          children: _allMills.map((mill) =>
                              CheckboxListTile(
                                title: Text(mill.LOC_CODE + "_" + mill.LOC_LOCATION_NAME),
                                value: _selectedMills.any((smill) => smill.LOC_ID == mill.LOC_ID),//selectedMills.contains(mill)? false:true,
                                onChanged: (val) {
                                  setState(() {
                                    if(val== true) {
                                      _selectedMills.add(mill);
                                      if(_removedMills.any((smill) => smill.LOC_ID == mill.LOC_ID))
                                      {
                                        _removedMills.removeWhere((element) => element.LOC_ID == mill.LOC_ID);
                                      }
                                    }else{
                                      if(_selectedMills.any((smill) => smill.LOC_ID == mill.LOC_ID)) {
                                        _selectedMills.removeWhere((element) => element.LOC_ID == mill.LOC_ID);
                                      }
                                      _removedMills.add(mill);
                                    }
                                  });
                                },
                              )).toList(),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty
                                      .resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                        return Color(0xffe6963e);
                                      }),
                                  foregroundColor: MaterialStateProperty
                                      .resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                        return Colors.white;
                                      }),
                                ),
                                onPressed: () {
                                  _addNewLocation();
                                  Navigator.pop(context);
                                },
                                child: Text('Add'),
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
/*
  Future _loadLocationList() async
  {
    var value = await _externalCropBL.getnotAssignedMills();
    if(value == null){
      var baseDialog = BaseAlertDialog(
        title: "Alert",
        content: "Network Connection Error.",
        yesOnPressed: () {Navigator.pop(context);},
        yes: "OK",
      );
      showDialog(context: context, builder: (BuildContext context) => baseDialog);
      return null;
    }
    else{
        var allMillList = value;
        _allMills.clear();
        _selectedMills.clear();
        _removedMills.clear();
        for(int i=0;i<allMillList.length;i++)
        {
          _allMills.add(allMillList[i]);
        }

        for(int jj=0;jj<_ecMillDetailList.length;jj++)
        {
          ECMillDetail loc = _ecMillDetailList[jj];
          for(int kk=0;kk<_allMills.length;kk++)
          {
            Mill seMill = _allMills[kk];
            if(seMill.LOC_ID == loc.millID)
            {
              _selectedMills.add(seMill);
            }
          }
        }
        return _allMills;
      }
  }
*/
  _addNewLocation()
  {
    List<ECMillDetail> addingLocationList =[];
    List<ECMillDetail> removingLocationList =[];

    if(_selectedMills.isNotEmpty)
    {
      for(int x=0;x<_selectedMills.length;x++)
      {
        Mill _selectedMill = _selectedMills[x];
        bool isExists = false;
        if(_ecMillDetailList.isNotEmpty)
        {
          for(int y=0;y<_ecMillDetailList.length;y++)
          {
            ECMillDetail selectedLocation = _ecMillDetailList[y];
            if(_selectedMill.LOC_ID == selectedLocation.millID)
            {
              isExists = true;
            }
          }
          if(!isExists)
          {
            ECMillDetail newLocation = new ECMillDetail(millID: _selectedMill.LOC_ID, millCode: _selectedMill.LOC_CODE, purchaseMillName: _selectedMill.LOC_LOCATION_NAME, pQty: 0, ratePerMT: 0, penaltyPerc: 0, penaltyCost: 0);
            addingLocationList.add(newLocation);
          }
        }
      }
    }

    if(_removedMills.isNotEmpty)
    {
      for(int x=0;x<_removedMills.length;x++)
      {
        Mill _removedMill = _removedMills[x];
        if(_ecMillDetailList.isNotEmpty)
        {
          for(int y=0;y<_ecMillDetailList.length;y++)
          {
            ECMillDetail selectedLocation = _ecMillDetailList[y];
            if(_removedMill.LOC_ID == selectedLocation.millID)
            {
              removingLocationList.add(selectedLocation);
            }
          }
        }
      }
    }

    setState(() {
      if(addingLocationList.isNotEmpty)
        {
          _ecMillDetailList.addAll(addingLocationList);
        }
      if(removingLocationList.isNotEmpty)
      {
        for(int yy=0;yy<removingLocationList.length;yy++)
        {
          _ecMillDetailList.remove(removingLocationList[yy]);
        }
      }
      _dataECMillDetail = LocationItemDetail(_ecMillDetailList,_currentLocationHeader,context);

    });
  }

  _SaveLocationData()   // Type  1- Save, 2 - Update
  {
    if (!_isSaveButtonPressed) {
      EasyLoading.show();
      _isSaveButtonPressed = true;
      List<ECMillDetail> ecLineList = [];

      for (int l = 0; l < _ecMillDetailList.length; l++) {
        if (_ecMillDetailList[l].pQty > 0 /*&& _ecMillDetailList[l].ratePerMT > 0*/) {
          ecLineList.add(_ecMillDetailList[l]);
        }
      }
      var ecMillDetailJson = jsonEncode(
          ecLineList.map((e) => e.toMap()).toList());
      LocationHeader lcheader = new LocationHeader(
          ECH_ID: _currentLocationHeader.ECH_ID,
          ECH_PURCHASED_ID: "",
          ECH_INCENTIVE_PER_MT: double.parse(
              _currentLocationHeader.ECH_INCENTIVE_PER_MT.toStringAsFixed(3)),
          ECH_TOTAL_PURCHASED_QTY: _currentLocationHeader
              .ECH_TOTAL_PURCHASED_QTY,
          ECH_INCENTIVE: double.parse(
              _currentLocationHeader.ECH_INCENTIVE.toStringAsFixed(3)),
          ECH_EXTERNAL_CROP_COST: double.parse(
              _currentLocationHeader.ECH_EXTERNAL_CROP_COST.toStringAsFixed(3)),
          ECH_COST_AVG_PER_MT: double.parse(
              _currentLocationHeader.ECH_COST_AVG_PER_MT.toStringAsFixed(3)),
          ECH_TOTAL_PENALTY_COST: double.parse(
              _currentLocationHeader.ECH_TOTAL_PENALTY_COST.toStringAsFixed(3)),
          ECH_COST_AFTER_PENALTY: double.parse(
              _currentLocationHeader.ECH_COST_AFTER_PENALTY.toStringAsFixed(3)),
          ECH_CONFIRMED: 0,
          ecMillDetailList: ecLineList,
          ECH_PURCHASE_DATE: DateTime.parse(_dateinput.text),
          isUpdate: false);

      var locationheaderJson = jsonEncode(lcheader.toMap());
      _externalCropBL.sendExternalCropData(
          locationheaderJson, ecMillDetailJson).then((value) {
        EasyLoading.dismiss();
        _isSaveButtonPressed = false;
        if (value == null) {
          var baseDialog = BaseAlertDialog(
            title: "Alert",
            content: "Network Connection Error.",
            yesOnPressed: () {
              Navigator.pop(context);
            },
            yes: "OK",
          );
          showDialog(
              context: context, builder: (BuildContext context) => baseDialog);
        }
        else if (value) {
          setState(() {
            _ecMillDetailList.clear();
            _selectedMills.clear();
            _removedMills.clear();
            _showAddECMillDetail = false;
            _currentLocationHeader.isUpdate = false;
          });
          var baseDialog = BaseAlertDialog(
            title: "Alert",
            content: "Saved Successfully.",
            yesOnPressed: () {
              Navigator.pop(context);
            },
            yes: "OK",
          );
          showDialog(
              context: context, builder: (BuildContext context) => baseDialog);
        } else {
          var baseDialog = BaseAlertDialog(
            title: "Alert",
            content: "Error Occured.Please Try Again.",
            yesOnPressed: () {
              Navigator.pop(context);
            },
            yes: "OK",
          );
          showDialog(
              context: context, builder: (BuildContext context) => baseDialog);
        }
      });
    }
  }

  _unableToEdit(){
    var baseDialog = BaseAlertDialog(
      title: "Alert",
      content: "Can not proceed. This record has been approved.",
      yesOnPressed: () {
        Navigator.pop(context);
      },
      yes: "OK",
    );
    showDialog(
        context: context, builder: (BuildContext context) => baseDialog);
  }

}