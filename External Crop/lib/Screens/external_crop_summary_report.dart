import 'package:external_crop/Bll/externalcropsummaryreportbl.dart';
import 'package:external_crop/Objects/ecreportitem.dart';
import 'package:external_crop/Utils/globl.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:external_crop/Objects/location.dart';
import 'package:external_crop/Objects/mill.dart';
import 'package:external_crop/Widget/external_crop_summary_report_header.dart';
import 'package:external_crop/Utils/ecreportitemresultsdatasource.dart';
import 'package:external_crop/Widget/base_alert_dialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io' as io;
import 'package:permission_handler/permission_handler.dart';

class ExternalCropSummaryReport extends StatefulWidget {
  @override
  _ExternalCropSummaryReport createState() => _ExternalCropSummaryReport();
}

class _ExternalCropSummaryReport extends State<ExternalCropSummaryReport> {
  TextEditingController startdateinput = TextEditingController();
//  TextEditingController enddateinput = TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  List<Location> locations = [];
  List<Location> selectedLocation = [];
  List<Mill> _assigedMillList =[];
  List<DropdownMenuItem<String>> _millList = [];
  ExternalCropSummaryReportBL externalCropSummaryReportBL = ExternalCropSummaryReportBL() ;
  ECReportItemResultsDataSource _resultsDataSource = ECReportItemResultsDataSource([]);
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  bool _showReportSummary = false;

  bool sort = false;
  int selectedIndex = -1;
  Color color ;
  bool _isChecked = false;
  String _dropDownSelectedValue = "0";

  @override
  void initState() {
    startdateinput.text = ""; //set the initial value of text field
 //   enddateinput.text = ""; //set the initial value of text field
    sort = false;
    selectedLocation = [];
    _loadNewLocationList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
        body: Stack(
          children: [
            ExternalCropSummaryReportHeader(),
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

                  child: Table(defaultVerticalAlignment: TableCellVerticalAlignment.top,
                    border: TableBorder.symmetric(inside: BorderSide(color: Colors.white70) ) ,
                    columnWidths: {
                      0: FlexColumnWidth(5),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(5),
                    },
                    children: [
                      TableRow(
                          children: [
                            SizedBox(
                              height: 60,
                              child : Text("Month",style: TextStyle(
                                fontSize: 18,
                              ),) , //Text("Total Purchased QTY:"),
                            ),
                            SizedBox(child: Text(":"),),
                            SizedBox(
                              child : TextFormField(
                                controller: startdateinput,
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: 'Select a date',
                                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),
                                ),
                                onTap: () async {
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
                                      startdateinput.text = formattedDate;
                                    });
                                  }else{
                                    print("Month is not selected");
                                  }
                                },
                              ),
                            ),
                         ]),
/*
                      TableRow(
                          children: [
                            SizedBox(height: 60,
                              child : Text("End Date",style: TextStyle(
                                fontSize: 18,
                              ),) ,
                            ),
                            SizedBox(child: Text(":"),),
                            SizedBox(
                              child : TextFormField(
                                controller: enddateinput,
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: 'Select a date',
                                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),
                                ),
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context, initialDate: DateTime.now(),
                                      builder: (BuildContext context, Widget ?child) {
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
                                                primary: Color(0xffffbc00),
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
                                      }
                                      firstDate: DateTime(DateTime.now().year - 10), //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime.now()
                                  );

                                  if(pickedDate != null ){
                                    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                    setState(() {
                                      enddateinput.text = formattedDate;
                                    });
                                  }else{
                                    print("End date is not selected");
                                  }
                                },
                              ),
                            ),
                         ]),
*/
                      TableRow(
                          children: [
                            SizedBox(
                              child : Text("Mill",style: TextStyle(
                                fontSize: 18,
                              ),) ,
                            ),
                            SizedBox(child: Text(":"),),
                            SizedBox(
                              child : DropdownButtonFormField(
                                isExpanded: true,
                                decoration: InputDecoration(isDense: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white, width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                dropdownColor: Colors.white,
                                  value: _dropDownSelectedValue,
                                  items: _millList,
                                  onChanged: (String newValue){
                                    setState(() {
                                      _dropDownSelectedValue = newValue;
                                    });
                                  },
                              ),
                            ),
                          ]),
/*
                      TableRow(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child : Text("Show Full Month",style: TextStyle(
                                fontSize: 18,
                              ),) ,
                            ),
                            Container(
                              alignment: Alignment.topLeft,child: Text(":"),),
                            Container(
                            alignment: Alignment.topLeft,
                              child : Checkbox(
                                value: _isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isChecked = value == null? false:value;
                                  });
                                },
                              ),
                            ),
                          ]),
*/
                      TableRow(
                          children: [
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
                                onPressed: _getReportData,
                                child: Text('View'),
                              ) , //Text("Total Purchased QTY:"),
                            ),
                            SizedBox(),
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
                                onPressed: _printReport,
                                child: Text('Save'),
                              ) , //Text("Total Purchased QTY:"),
                            ),
                          ]),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),

              Visibility(
                visible: _showReportSummary,
                child:Material(
                      shadowColor: Colors.white.withOpacity(0.01), // added
                      type: MaterialType.card,
                      elevation: 10,
                      borderRadius: new BorderRadius.circular(10.0),

                      child: Column(
                          children: [
                            Container(margin: EdgeInsets.all(5),
                              color: Colors.white,

                              child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "External Crop Summary",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                        child: Container(
                                          width: 510,
                                          height:510,
                                          child: ListView(
                                          padding: const EdgeInsets.all(3.0),
                                          shrinkWrap: true,
                                          children: <Widget>[
                                        PaginatedDataTable(
                                            rowsPerPage: _rowsPerPage,
                                            onRowsPerPageChanged: (int value) {
                                              setState(() {
                                                _rowsPerPage = value;
                                              });
                                            },
                                            columns: <DataColumn>[
                                              DataColumn(
                                                  label: const Text(''),),
                                              DataColumn(
                                                  label: const Text('Date'),
                                                  numeric: false,),
                                              DataColumn(
                                                  label: const Text('1'),
                                                  numeric: true,),
                                              DataColumn(
                                                  label: const Text('2'),
                                                  numeric: true,),
                                              DataColumn(
                                                  label: const Text('3'),
                                                  numeric: true,),
                                              DataColumn(
                                                label: const Text('4'),
                                                numeric: true,),
                                              DataColumn(
                                                label: const Text('5'),
                                                numeric: true,),
                                              DataColumn(
                                                label: const Text('6'),
                                                numeric: true,),
                                              DataColumn(
                                                label: const Text('7'),
                                                numeric: true,),
                                              DataColumn(
                                                label: const Text('8'),
                                                numeric: true,),
                                              DataColumn(
                                                label: const Text('9'),
                                                numeric: true,),
                                              DataColumn(
                                                label: const Text('10'),
                                                numeric: true,),
                                              DataColumn(
                                                label: const Text('11'),
                                                numeric: true,),
                                              DataColumn(
                                                label: const Text('12'),
                                                numeric: true,),
                                              DataColumn(
                                                label: const Text('13'),
                                                numeric: true,),
                                              DataColumn(
                                                label: const Text('14'),
                                                numeric: true,),
                                              DataColumn(
                                                label: const Text('15'),
                                                numeric: true,),
                                              DataColumn(
                                                label: const Text('16'),
                                                numeric: true,),
                                              DataColumn(
                                                label: const Text('17'),
                                                numeric: true,),
                                              DataColumn(
                                                label: const Text('18'),
                                                numeric: true,),
                                              DataColumn(
                                                label: const Text('19'),
                                                numeric: true,),
                                              DataColumn(
                                                label: const Text('20'),
                                                numeric: true,),
                                              DataColumn(
                                                label: const Text('21'),
                                                numeric: true,),
                                              DataColumn(
                                                label: const Text('22'),
                                                numeric: true,),
                                              DataColumn(
                                                label: const Text('23'),
                                                numeric: true,),
                                              DataColumn(
                                                label: const Text('24'),
                                                numeric: true,),
                                              DataColumn(
                                                label: const Text('25'),
                                                numeric: true,),
                                              DataColumn(
                                                label: const Text('26'),
                                                numeric: true,),
                                              DataColumn(
                                                label: const Text('27'),
                                                numeric: true,),
                                              DataColumn(
                                                label: const Text('28'),
                                                numeric: true,),
                                              DataColumn(
                                                label: const Text('29'),
                                                numeric: true,),
                                              DataColumn(
                                                label: const Text('30'),
                                                numeric: true,),
                                              DataColumn(
                                                label: const Text('31'),
                                                numeric: true,),
                                            ],
                                            source: _resultsDataSource)
                                      ])
                                        ),


                                    ),
                                  ),


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

    void _onCheckBoxChanged(bool newValue) => setState(() {
      _isChecked = newValue;

      if (_isChecked) {
        // TODO: Here goes your functionality that remembers the user.
      } else {
        // TODO: Forget the user
      }
    });
  }

  _loadNewLocationList() async {

    _millList.add(DropdownMenuItem(child: Text("--All--"),value: "0"));
    await externalCropSummaryReportBL.getAssignedMills().then((value) {
      if(value == "null"){
        var baseDialog = BaseAlertDialog(
          title: "Alert",
          content: "Unable to load Mills.Network error occurred .",
          yesOnPressed: () {Navigator.pop(context);},
          yes: "OK",
        );
        showDialog(context: context, builder: (BuildContext context) => baseDialog);
      }
      else
      {
        List<Mill> mills = value;
        Mill allMillOb = Mill(LOC_ID: 0, LOC_LOCATION_NAME: "All", LOC_CODE: "", LOC_DESCRIPTION: "");
        _assigedMillList.add(allMillOb);
        _assigedMillList.addAll(mills);
        setState(() {
          for(var i=0;i<mills.length;i++)
          {
            _millList.add(DropdownMenuItem(child: Container(
              width: 200,
              child: Text(mills[i].LOC_LOCATION_NAME,),
            ),value: mills[i].LOC_ID.toString()));
          }
        });
      }
    });
  }

  _getReportData() async {

    EasyLoading.show();
    setState(() {
      _showReportSummary = false;
    });

    if(startdateinput.text.trim() ==""){
      EasyLoading.dismiss();
      var baseDialog = BaseAlertDialog(
        title: "Alert",
        content: "Please Select a month.",
        yesOnPressed: () {Navigator.pop(context);},
        yes: "OK",
      );
      showDialog(context: context, builder: (BuildContext context) => baseDialog);
    }
    else {
      externalCropSummaryReportBL.getReportData(
          DateTime.parse(startdateinput.text),int.parse(_dropDownSelectedValue.toString())).then((value) {
        EasyLoading.dismiss();
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
        else {
          if (value.length > 0) {
            setState(() {
              _resultsDataSource = ECReportItemResultsDataSource(value);
              _showReportSummary = true;
            });
          }
          else {
            var baseDialog = BaseAlertDialog(
              title: "Alert",
              content: "No Data to view.",
              yesOnPressed: () {
                Navigator.pop(context);
              },
              yes: "OK",
            );
            showDialog(context: context,
                builder: (BuildContext context) => baseDialog);
          }
        }
      });
    }
  }

  _printReport() async {

    EasyLoading.show();
    setState(() {
      _showReportSummary = false;
    });

    if(startdateinput.text.trim() ==""){
      EasyLoading.dismiss();
      var baseDialog = BaseAlertDialog(
        title: "Alert",
        content: "Please Select a month.",
        yesOnPressed: () {Navigator.pop(context);},
        yes: "OK",
      );
      showDialog(context: context, builder: (BuildContext context) => baseDialog);
    }
    else {
      externalCropSummaryReportBL.getReportData(
          DateTime.parse(startdateinput.text),int.parse(_dropDownSelectedValue.toString())).then((value) {
        EasyLoading.dismiss();
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
        else {
          if (value.length > 0) {
            _printPDF(value);
          }
          else {
            var baseDialog = BaseAlertDialog(
              title: "Alert",
              content: "No data to save.",
              yesOnPressed: () {
                Navigator.pop(context);
              },
              yes: "OK",
            );
            showDialog(context: context,
                builder: (BuildContext context) => baseDialog);
          }
        }
      });
    }
  }


  _printPDF(value) async {
    try {
      PdfDocument document = PdfDocument();
      document.pageSettings.size = PdfPageSize.a4;
      document.pageSettings.orientation =PdfPageOrientation.landscape;

      final PdfPageTemplateElement headerTemplate =
      PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 550, 50));

      DateTime selecteddate  = DateTime.parse(startdateinput.text);
      String date = selecteddate.year.toString()+"-"+DateFormat("MMMM").format(selecteddate);;
      DateTime currenttime = DateTime.now();
      String cTime = DateFormat('yyyy-MM-dd').format(currenttime);
       Mill mill = _assigedMillList.elementAt(0);
       for(int ii =0; ii<_assigedMillList.length;ii++ ){
        if(_assigedMillList[ii].LOC_ID == int.parse(_dropDownSelectedValue)) {
          mill = _assigedMillList[ii];
          break;
        }
       }
      headerTemplate.graphics.drawString(
          'External Crop Summary Report', PdfStandardFont(PdfFontFamily.timesRoman, 12),
          bounds: const Rect.fromLTWH(200, 0, 200, 20));
      headerTemplate.graphics.drawString(
          'Month :'+ date, PdfStandardFont(PdfFontFamily.timesRoman, 8),
          bounds: const Rect.fromLTWH(50, 25, 200, 20));
      headerTemplate.graphics.drawString(
          'Mill :'+ mill.LOC_LOCATION_NAME, PdfStandardFont(PdfFontFamily.timesRoman, 8),
          bounds: const Rect.fromLTWH(450, 25, 200, 20));
      headerTemplate.graphics.drawString(
          'User  :'+ Globle.userName, PdfStandardFont(PdfFontFamily.timesRoman, 8),
          bounds: const Rect.fromLTWH(50, 40, 200, 20));
      headerTemplate.graphics.drawString(
          'Date :'+ cTime, PdfStandardFont(PdfFontFamily.timesRoman, 8),
          bounds: const Rect.fromLTWH(450, 40, 200, 20));


      document.template.top = headerTemplate;

      PdfGrid grid = PdfGrid();
      grid.columns.add(count: 33);
      grid.headers.add(1);

      PdfGridRow header = grid.headers[0];
      header.cells[0].value = '';
      header.cells[1].value = 'Date';
      header.cells[2].value = '1';
      header.cells[3].value = '2';
      header.cells[4].value = '3';
      header.cells[5].value = '4';
      header.cells[6].value = '5';
      header.cells[7].value = '6';
      header.cells[8].value = '7';
      header.cells[9].value = '8';
      header.cells[10].value = '9';
      header.cells[11].value = '10';
      header.cells[12].value = '11';
      header.cells[13].value = '12';
      header.cells[14].value = '13';
      header.cells[15].value = '14';
      header.cells[16].value = '15';
      header.cells[17].value = '16';
      header.cells[18].value = '17';
      header.cells[19].value = '18';
      header.cells[20].value = '19';
      header.cells[21].value = '20';
      header.cells[22].value = '21';
      header.cells[23].value = '22';
      header.cells[24].value = '23';
      header.cells[25].value = '24';
      header.cells[26].value = '25';
      header.cells[27].value = '26';
      header.cells[28].value = '27';
      header.cells[29].value = '28';
      header.cells[30].value = '29';
      header.cells[31].value = '30';
      header.cells[32].value = '31';

      final List<ECReportItem> _results = value;
      if(_results.length > 0){
        PdfGridRow row = grid.rows.add();
        for(int x=0; x<_results.length;x++){
          row.cells[0].value = _results[x].DESCRIPTION;
          row.cells[1].value = _results[x].LOCATION_NAME;
          row.cells[2].value = _results[x].DAY_1_VALUE.toString();
          row.cells[3].value = _results[x].DAY_2_VALUE.toString();
          row.cells[4].value = _results[x].DAY_3_VALUE.toString();
          row.cells[5].value = _results[x].DAY_4_VALUE.toString();
          row.cells[6].value = _results[x].DAY_5_VALUE.toString();
          row.cells[7].value = _results[x].DAY_6_VALUE.toString();
          row.cells[8].value = _results[x].DAY_7_VALUE.toString();
          row.cells[9].value = _results[x].DAY_8_VALUE.toString();
          row.cells[10].value = _results[x].DAY_9_VALUE.toString();
          row.cells[11].value = _results[x].DAY_10_VALUE.toString();
          row.cells[12].value = _results[x].DAY_11_VALUE.toString();
          row.cells[13].value = _results[x].DAY_12_VALUE.toString();
          row.cells[14].value = _results[x].DAY_13_VALUE.toString();
          row.cells[15].value = _results[x].DAY_14_VALUE.toString();
          row.cells[16].value = _results[x].DAY_15_VALUE.toString();
          row.cells[17].value = _results[x].DAY_16_VALUE.toString();
          row.cells[18].value = _results[x].DAY_17_VALUE.toString();
          row.cells[19].value = _results[x].DAY_18_VALUE.toString();
          row.cells[20].value = _results[x].DAY_19_VALUE.toString();
          row.cells[21].value = _results[x].DAY_20_VALUE.toString();
          row.cells[22].value = _results[x].DAY_21_VALUE.toString();
          row.cells[23].value = _results[x].DAY_22_VALUE.toString();
          row.cells[24].value = _results[x].DAY_23_VALUE.toString();
          row.cells[25].value = _results[x].DAY_24_VALUE.toString();
          row.cells[26].value = _results[x].DAY_25_VALUE.toString();
          row.cells[27].value = _results[x].DAY_26_VALUE.toString();
          row.cells[28].value = _results[x].DAY_27_VALUE.toString();
          row.cells[29].value = _results[x].DAY_28_VALUE.toString();
          row.cells[30].value = _results[x].DAY_29_VALUE.toString();
          row.cells[31].value = _results[x].DAY_30_VALUE.toString();
          row.cells[32].value = _results[x].DAY_31_VALUE.toString();
          if(_results.length-1 > x) {
            row = grid.rows.add();
          }
        }
      }

      grid.style = PdfGridStyle(
          cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
          backgroundBrush: PdfBrushes.white,
          textBrush: PdfBrushes.black,
          font: PdfStandardFont(PdfFontFamily.timesRoman, 10));

      grid.draw(
          page: document.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0));

      io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
      final dbFolder = documentsDirectory.path;

   //   File source1 = File('$dbFolder/External_Crop.db');

      io.Directory copyTo = io.Directory("storage/emulated/0/EC_Report");

      if ((await copyTo.exists())) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        }
      }
      else {
        EasyLoading.dismiss();
        if (await Permission.storage
            .request()
            .isGranted) {
          // Either the permission was already granted before or the user just granted it.
          await copyTo.create();
        }
        else {
          var baseDialog = BaseAlertDialog(
            title: "Alert",
            content: "Please give permission.",
            yesOnPressed: () {
              Navigator.pop(context);
            },
            yes: "OK",
          );
          showDialog(
              context: context, builder: (BuildContext context) => baseDialog);
        }
      }

        final pdfName = '${copyTo.path}/Report_'+mill.LOC_LOCATION_NAME+'_'+date+'.pdf';
        final fileName = io.File(pdfName);
        fileName.writeAsBytes(await document.save());
        document.dispose();

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

    }
    catch(exception){
      throw exception.toString();
    }
  }




}