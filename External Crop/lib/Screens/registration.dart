import 'dart:async';
import 'package:external_crop/Bll/registrationbl.dart';
import 'package:external_crop/Objects/entity.dart';
import 'package:external_crop/Objects/vehicle.dart';
import 'package:external_crop/Widget/base_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:external_crop/Widget/registration_header.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class Registration extends StatefulWidget {

  const Registration({Key key}) : super(key: key);

  @override
  _Registration createState() => _Registration();
}

class RecordEditor {
  String millID = "";
  String vehicleID = "";
}

enum selectingType { Vehicle, Supplier }

class _Registration extends State<Registration> {
  bool _supportsNFC = false;

  RegistrationBL registrationBL = RegistrationBL() ;
  Stream<NDEFMessage> _stream = null;
  int _isTempVehicle = 0;
  bool _showVehicleSelect =true;
  bool _showSupplierSelect = false;

  String _selectedSupplierValue ="0";
  String _selectedVehicleValue ="0";

  selectingType _character = selectingType.Vehicle;

  List<DropdownMenuItem> _allVehicleList = [];
  List<DropdownMenuItem> _allSupplierList = [];

  List<DropdownMenuItem<String>> _entityList = [];
  List<DropdownMenuItem<String>> _vehicleListBySupplier = [];

  String _selectedFullVehicleValue ="0";
  String _selectedFiltedSupplierValue ="0";

  String _selectedFullSupplierValue ="0";
  String _selectedFilteredVehicleValue ="0";

  @override
  void initState() {
    _loadVehicleList();
    _loadSupplierListByVehicleID(0,0);
    _loadAllSupplierList();
    _loadVehicleListBySupplier(0);
    super.initState();
    NFC.isNDEFSupported.then((supported) {
      setState(() {
         _supportsNFC = supported;
      });
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    EasyLoading.dismiss();
    print('Dispose used');
    super.dispose();

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
            RegistrationHeader(),
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

                  child:
                  Table(defaultVerticalAlignment: TableCellVerticalAlignment.top,
                    border: TableBorder.symmetric(inside: BorderSide(color: Colors.white70) ) ,
                    columnWidths: {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(1),
                    },

                    children: [
                      TableRow(
                          children: [
                            SizedBox(
                              child : ListTile(
                                title: const Text('Vehicle'),
                                leading: Radio<selectingType>(
                                  value: selectingType.Vehicle,
                                  groupValue: _character,
                                  onChanged: (selectingType value) {
                                    setState(() {
                                      _character = value;
                                      _showSupplierSelect = false;
                                      _showVehicleSelect = true;
                                      _selectedVehicleValue ="0";
                                      _selectedSupplierValue ="0";

                                      _selectedFilteredVehicleValue ="0";
                                      _selectedFullSupplierValue ="0";
                                      _selectedFullVehicleValue ="0";
                                      _selectedFiltedSupplierValue ="0";

                                    });

                                    _loadSupplierListByVehicleID(0,0);
                                    _loadVehicleListBySupplier(0);
                                  },
                                ),
                              ) ,
                            ),
                            SizedBox(
                              child : ListTile(
                                title: const Text('Supplier'),
                                leading: Radio<selectingType>(
                                  value: selectingType.Supplier,
                                  groupValue: _character,
                                  onChanged: (selectingType value) {
                                    setState(() {
                                      _character = value;
                                      _showSupplierSelect = true;
                                      _showVehicleSelect = false;
                                      _selectedVehicleValue ="0";
                                      _selectedSupplierValue ="0";

                                      _selectedFilteredVehicleValue ="0";
                                      _selectedFullSupplierValue ="0";
                                      _selectedFullVehicleValue ="0";
                                      _selectedFiltedSupplierValue ="0";

                                    });
                                    _loadSupplierListByVehicleID(0,0);
                                    _loadVehicleListBySupplier(0);
                                  },
                                ),
                              ),
                            ),
                          ]),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),

              Visibility(
                visible: _showVehicleSelect,
                child:Material(
                    shadowColor: Colors.white.withOpacity(0.01), // added
                    type: MaterialType.card,
                    elevation: 10, borderRadius: new BorderRadius.circular(15.0),
                    child : Container(
                      margin: EdgeInsets.all(5),
                      color: Colors.white,

                      child:
                        Table(defaultVerticalAlignment: TableCellVerticalAlignment.top,
                          border: TableBorder.symmetric(inside: BorderSide(color: Colors.white70) ) ,
                          columnWidths: {
                            0: FlexColumnWidth(3),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(7),
                          },

                      children: [
                        TableRow(
                            children: [
                              SizedBox(
                                child : Text("Vehicle ",style: TextStyle(
                                  fontSize: 18,
                                ),) ,
                              ),
                              SizedBox(child: Text(":"),),
                              SizedBox(
                                child : SearchableDropdown.single(
                                  items: _allVehicleList,
                                  value: _selectedFullVehicleValue,
                                  hint: "Select a vehicle",
                                  searchHint: "Select",
                                  onChanged: (newvalue) {
                                    setState(() {
                                      _isTempVehicle = 0;
                                      _selectedVehicleValue = "0";
                                      _selectedSupplierValue = "0";

                                      _selectedFilteredVehicleValue ="0";
                                      _selectedFullSupplierValue ="0";

                                      _selectedFiltedSupplierValue ="0";

                                      String newval ="";
                                      if(newvalue==null){
                                        newvalue ="0";
                                        newval ="0";
                                      }else{
                                        var splittable = newvalue.split('|');
                                        newval = splittable[0];
                                        _isTempVehicle = int.parse(splittable[1]);
                                      }
                                      _selectedVehicleValue = newval;
                                      _selectedFullVehicleValue = newval;
                                      _loadSupplierListByVehicleID(int.parse(newval),_isTempVehicle);
                                    });
                                  },
                                  isExpanded: true,
                                ),
                              ),
                            ]),


                          TableRow(children: [SizedBox(height: 10),SizedBox(height: 10),SizedBox(height: 10)]),
                          TableRow(
                            children: [
                              SizedBox(
                                child : Text("Supplier",style: TextStyle(
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
                                  value: _selectedFiltedSupplierValue,
                                  items: _entityList,
                                  onChanged: (String newValue){
                                    setState(() {
                                      _selectedSupplierValue = newValue;
                                      _selectedFiltedSupplierValue = newValue;
                                    });
                                  },
                                ),
                              ),
                            ]),
                          TableRow(children: [SizedBox(height: 10),SizedBox(height: 10),SizedBox(height: 10)]),
                          TableRow(children: [SizedBox(height: 10),SizedBox(height: 10),SizedBox(
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
                              onPressed: _printNFCCard,
                              child: Text('Print To Card'),
                            ) , //Text("Total Purchased QTY:"),
                          ),]),
                      ],
                    ),
                  ),
                  ),
              ),

              Visibility(
                visible: _showSupplierSelect,
                child:
                    Material(
                      shadowColor: Colors.white.withOpacity(0.01), // added
                      type: MaterialType.card,
                      elevation: 10, borderRadius: new BorderRadius.circular(15.0),
                      child : Container(
                        margin: EdgeInsets.all(5),
                        color: Colors.white,

                        child:
                        Table(defaultVerticalAlignment: TableCellVerticalAlignment.top,
                          border: TableBorder.symmetric(inside: BorderSide(color: Colors.white70) ) ,
                          columnWidths: {
                            0: FlexColumnWidth(3),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(7),
                          },

                          children: [

                            TableRow(
                                children: [
                                  SizedBox(
                                    child : Text("Supplier ",style: TextStyle(
                                      fontSize: 18,
                                    ),) ,
                                  ),
                                  SizedBox(child: Text(":"),),
                                  SizedBox(
                                    child : SearchableDropdown.single(
                                      items: _allSupplierList,
                                      value: _selectedFullSupplierValue,
                                      hint: "Select a supplier",
                                      searchHint: "Select",
                                      onChanged: (newvalue) {
                                        setState(() {
                                          _selectedFullVehicleValue ="0";
                                          _selectedFilteredVehicleValue ="0";

                                          _selectedSupplierValue ="0";
                                          _selectedVehicleValue ="0";
                                          _isTempVehicle = 0;

                                          String newval ="0";

                                          if(newvalue != null)
                                          {
                                            var splittable = newvalue.split('|');
                                            newval = splittable[0];
                                          }

                                          _selectedSupplierValue = newval;
                                          _selectedFullSupplierValue = newval;
                                          _loadVehicleListBySupplier(int.parse(newval));
                                        });
                                      },
                                      isExpanded: true,
                                    ),
                                  ),
                                ]),

                            TableRow(children: [SizedBox(height: 10),SizedBox(height: 10),SizedBox(height: 10)]),
                            TableRow(
                                children: [
                                  SizedBox(
                                    child : Text("Vehicle",style: TextStyle(
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
                                      value: _selectedFilteredVehicleValue,
                                      items: _vehicleListBySupplier,
                                      onChanged: (String newValue){
                                        setState(() {
                                          _isTempVehicle = 0;
                                          String newval ="0";
                                          if(newValue != null)
                                          {
                                            var splittable = newValue.split('|');
                                            newval = splittable[0];
                                            _isTempVehicle = int.parse(splittable[1]);
                                          }

                                          _selectedVehicleValue = newval;
                                          _selectedFilteredVehicleValue = newValue;
                                        });
                                      },
                                    ),
                                  ),
                                ]),
                            TableRow(children: [SizedBox(height: 10),SizedBox(height: 10),SizedBox(height: 10)]),
                            TableRow(children: [SizedBox(height: 10),SizedBox(height: 10),SizedBox(
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
                                onPressed: _printNFCCard,
                                child: Text('Print To Card'),
                              ) , //Text("Total Purchased QTY:"),
                            ),]),
                          ],
                        ),
                      ),
                    ),
              ),

          ],),
        ),
      ),
    );
  }

  _printNFCCard() async {

    if (!_supportsNFC) {

      var baseDialog = BaseAlertDialog(
        title: "Alert",
        content: "Your device does not support NFC.",
        yesOnPressed: () {Navigator.pop(context);},
        yes: "OK",
      );
      showDialog(context: context, builder: (BuildContext context) => baseDialog);
    }
    else
    {
      await registrationBL.getIsAvailableTempVehByVehID(int.parse(_selectedVehicleValue)).then((value) {
        if(value == true)
        {
          _stream = null;
          _stream = NFC.readNDEF();

          if (int.parse(_selectedSupplierValue) > 0 && int.parse(_selectedVehicleValue) > 0) {
            EasyLoading.show();
            List<RecordEditor> _records = [];
            RecordEditor recEdit = new RecordEditor();
            recEdit.vehicleID = _selectedVehicleValue.toString();
            recEdit.millID = _selectedSupplierValue.toString();
            _records.add(recEdit);

            List<NDEFRecord> records = _records.map((record) {
              return NDEFRecord.type(
                record.millID,
                record.millID + "_" + record.vehicleID+"_"+ _isTempVehicle.toString(),
              );
            }).toList();

            NDEFMessage message = NDEFMessage.withRecords(records);

            NFC.writeNDEF(message).first.then((value) {
              if (value.writable) {
                _addRecord();
                _records.clear();
                setState(() {
                  _stream = null;
                });
                EasyLoading.dismiss();
              }
            });
          }
          else
          {
            setState(() {
              _stream = null;
            });
            var baseDialog = BaseAlertDialog(
              title: "Alert",
              content: "Please Select a Supplier and a Vehicle.",
              yesOnPressed: () {Navigator.pop(context);},
              yes: "OK",
            );
            showDialog(context: context, builder: (BuildContext context) => baseDialog);
          }
        }
        else
        {
          var baseDialog = BaseAlertDialog(
            title: "Alert",
            content: "The vehicle is not available at the moment.Please select another vehicle.",
            yesOnPressed: () {Navigator.pop(context);},
            yes: "OK",
          );
          showDialog(context: context, builder: (BuildContext context) => baseDialog);
        }
      });
    }
  }

  _loadSupplierListByVehicleID(int vehicleID,int isTempVehicle) async {
    _entityList.clear();
    List<Entity> _assigedEntityList =[];

    _entityList.add(DropdownMenuItem(child: Text("--Select--"),value: "0"));
      await registrationBL.getAssignedMillsByVehicleID(vehicleID,isTempVehicle).then((entities) {
      _assigedEntityList.addAll(entities);
      setState(() {
        _assigedEntityList.map((_ent) {
          _entityList.add(DropdownMenuItem(child: Container(
            width: 200,
            child: Text(_ent.ECM_ALIAS+"-"+_ent.ECM_ENTITY_DESCRIPTION,),
          ),value: _ent.ECM_ENTITY_REF_ID.toString()));
        }).toList();
        
      });
    });
  }

  _loadAllSupplierList() async {
    _allSupplierList.clear();
    List<Entity> _assigedAllSupplierList =[];

    await registrationBL.getAllSupplierList().then((entities) {
      List<Entity> _entityAllList = entities;
      _assigedAllSupplierList.addAll(_entityAllList);
      setState(() {
        for (var i = 0; i < _assigedAllSupplierList.length; i++) {

          _allSupplierList.add(DropdownMenuItem(
            child: Text(_assigedAllSupplierList[i].ECM_ALIAS+"-"+_assigedAllSupplierList[i].ECM_ENTITY_DESCRIPTION,),
            value: _assigedAllSupplierList[i].ECM_ENTITY_REF_ID.toString()+"|"+_assigedAllSupplierList[i].ECM_ALIAS+"-"+_assigedAllSupplierList[i].ECM_ENTITY_DESCRIPTION,
          ));

        }
      });
    });
  }

  _loadVehicleListBySupplier(int supplierID) async {
    _vehicleListBySupplier.clear();
    List<Vehicle> _assigedVehicleListBySupplier  =[];

    _vehicleListBySupplier.add(DropdownMenuItem(child: Text("--Select--"),value: "0"));
    await registrationBL.getVehiclesByEntityID(supplierID).then((entities) {
      _assigedVehicleListBySupplier.addAll(entities);
      setState(() {
        _assigedVehicleListBySupplier.map((_ent) {
          _vehicleListBySupplier.add(DropdownMenuItem(child: Container(
            width: 200,
            child: Text(_ent.ECM_VEH_ALIAS+"-"+_ent.ECM_VEH_VEHICLE_DESCRIPTION,),
          ),value: _ent.ECM_VEH_VEHICLE_REF_ID.toString()+"|"+_ent.IS_TEMP.toString() ));
        }).toList();

      });
    });
  }

  _loadVehicleList() async {

    try {
      _allVehicleList.clear();
      List<Vehicle> _assigedVehicleList =[];

      await registrationBL.getVehicles().then((value) {
        List<Vehicle> vehicles = value;
        _assigedVehicleList.addAll(vehicles);
        setState(() {
          for (var i = 0; i < _assigedVehicleList.length; i++) {

            _allVehicleList.add(DropdownMenuItem(
              child: Text(_assigedVehicleList[i].ECM_VEH_ALIAS+"-"+_assigedVehicleList[i].ECM_VEH_VEHICLE_DESCRIPTION,),
              value: _assigedVehicleList[i].ECM_VEH_VEHICLE_REF_ID.toString()+"|"+_assigedVehicleList[i].IS_TEMP.toString()+"|"+_assigedVehicleList[i].ECM_VEH_ALIAS+"-"+_assigedVehicleList[i].ECM_VEH_VEHICLE_DESCRIPTION,
            ));

          }
        });
      });
    }
    catch(es)
    {
//      EasyLoading.dismiss();
    }
  }


   _addRecord() async {
    await registrationBL.saveNFCVehicleData(int.parse(_selectedSupplierValue), int.parse(_selectedVehicleValue),_isTempVehicle).then((value) async {
      if(value == 1)
      {
        if(_isTempVehicle == 1)
        {
          await registrationBL.updateUsedTempVehicleByVehicleID(int.parse(_selectedVehicleValue)).then((retValue) {
            if(retValue == 1)
            {
              if(_character == selectingType.Vehicle)
              {
                setState(() {
                  _selectedFiltedSupplierValue ="0";
                  _selectedFullSupplierValue ="0";
                  _selectedFilteredVehicleValue ="0";

                  _selectedSupplierValue = "0";
                });
              }
              else
              {
                setState(() {
                  _selectedFiltedSupplierValue ="0";
                  _selectedFilteredVehicleValue ="0";
                  _selectedFullVehicleValue="0";

                  _selectedVehicleValue = "0";
                });
              }

              var baseDialog = BaseAlertDialog(
                title: "Alert",
                content: "Completed successfully.",
                yesOnPressed: () {
                  Navigator.pop(context);
                },
                yes: "OK",
              );
              showDialog(context: context, builder: (BuildContext context) => baseDialog);
            }
            else{
              var baseDialog = BaseAlertDialog(
                title: "Alert",
                content: "Error occured. Please Try Again.",
                yesOnPressed: () {
                  Navigator.pop(context);
                },
                yes: "OK",
              );
              showDialog(context: context, builder: (BuildContext context) => baseDialog);
            }
          });
        }
        else
        {
          var baseDialog = BaseAlertDialog(
            title: "Alert",
            content: "Completed successfully.",
            yesOnPressed: () {

              if(_character == selectingType.Vehicle)
              {
                setState(() {
                  _selectedSupplierValue = "0";

                  _selectedFiltedSupplierValue ="0";
                  _selectedFullSupplierValue ="0";
                  _selectedFilteredVehicleValue ="0";

                });
              }
              else
              {
                setState(() {
                  _selectedVehicleValue = "0";

                  _selectedFiltedSupplierValue ="0";
                  _selectedFilteredVehicleValue ="0";
                  _selectedFullVehicleValue = "0";

                });
              }
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
          content: "Error occured. Please Try Again.",
          yesOnPressed: () {
            Navigator.pop(context);
            },
          yes: "OK",
        );
        showDialog(context: context, builder: (BuildContext context) => baseDialog);
      }
    });
  }

}

