import 'package:external_crop/Objects/locationheader.dart';
import 'package:flutter/material.dart';
import 'package:external_crop/Widget/pending_ec_list_header.dart';
import 'package:external_crop/Bll/pendinglistbl.dart';
import 'package:external_crop/Widget/pending_list_data.dart';


class Pending_ECList extends StatefulWidget {
  @override
  _Pending_ECList createState() => _Pending_ECList();
}

class _Pending_ECList extends State<Pending_ECList> {

  PendingListBL pendingListBL = new PendingListBL();
  DataTableSource _data;

  @override
  void initState() {
    List<LocationHeader> _dataList = [];
    _data = PendingListData(_dataList,context);
    pendingListBL.getPendingExternalCropHeader().then((value) {
      setState(() {
        _data = PendingListData(value,context);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        body: Stack(
          children: [
            PendingECHeader(),
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
                                  "Pending List",
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
                                                source: _data,
                                                columns: const [
                                                  DataColumn(label: Text('')),
                                                  DataColumn(label: Text('')),
                                                  DataColumn(label: Text('')),
                                                  DataColumn(label: Text('ID')),
                                                  DataColumn(label: Text('PURCHASED DATE')),
                                                  DataColumn(label: Text('TOTAL PURCHASED QTY')),
                                                  DataColumn(label: Text('EXTERNAL CROP COST')),
                                                  DataColumn(label: Text('COST AVG. PER MT')),
                                                  DataColumn(label: Text('TOTAL PENALTY COST')),
                                                  DataColumn(label: Text('COST AFTER PENALTY')),
                                                ],
                                                columnSpacing: 30,
                                                horizontalMargin: 10,
                                                rowsPerPage: 5,
                                                showCheckboxColumn: false,
                                              ),
                                            ])
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
              ]),
          ),
        ),

    );
  }
}


