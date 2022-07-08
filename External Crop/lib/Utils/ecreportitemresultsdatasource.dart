import 'package:flutter/material.dart';
import 'package:external_crop/Objects/ecreportitem.dart';

class ECReportItemResultsDataSource extends DataTableSource {
  final List<ECReportItem> _results;
  ECReportItemResultsDataSource(this._results);

  void _sort<T>(Comparable<T> getField(ECReportItem d), bool ascending) {
    _results.sort((ECReportItem a, ECReportItem b) {
      if (!ascending) {
        final ECReportItem c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _results.length) return null;
    final ECReportItem result = _results[index];
    return DataRow.byIndex(
        index: index,
        selected: false,
        cells: <DataCell>[
          DataCell(Text('${result.DESCRIPTION}')),
          DataCell(Text('${result.LOCATION_NAME}')),
          DataCell(Text('${result.DAY_1_VALUE}')),
          DataCell(Text('${result.DAY_2_VALUE}')),
          DataCell(Text('${result.DAY_3_VALUE}')),
          DataCell(Text('${result.DAY_4_VALUE}')),
          DataCell(Text('${result.DAY_5_VALUE}')),
          DataCell(Text('${result.DAY_6_VALUE}')),
          DataCell(Text('${result.DAY_7_VALUE}')),
          DataCell(Text('${result.DAY_8_VALUE}')),
          DataCell(Text('${result.DAY_9_VALUE}')),
          DataCell(Text('${result.DAY_10_VALUE}')),
          DataCell(Text('${result.DAY_11_VALUE}')),
          DataCell(Text('${result.DAY_12_VALUE}')),
          DataCell(Text('${result.DAY_13_VALUE}')),
          DataCell(Text('${result.DAY_14_VALUE}')),
          DataCell(Text('${result.DAY_15_VALUE}')),
          DataCell(Text('${result.DAY_16_VALUE}')),
          DataCell(Text('${result.DAY_17_VALUE}')),
          DataCell(Text('${result.DAY_18_VALUE}')),
          DataCell(Text('${result.DAY_19_VALUE}')),
          DataCell(Text('${result.DAY_20_VALUE}')),
          DataCell(Text('${result.DAY_21_VALUE}')),
          DataCell(Text('${result.DAY_22_VALUE}')),
          DataCell(Text('${result.DAY_23_VALUE}')),
          DataCell(Text('${result.DAY_24_VALUE}')),
          DataCell(Text('${result.DAY_25_VALUE}')),
          DataCell(Text('${result.DAY_26_VALUE}')),
          DataCell(Text('${result.DAY_27_VALUE}')),
          DataCell(Text('${result.DAY_28_VALUE}')),
          DataCell(Text('${result.DAY_29_VALUE}')),
          DataCell(Text('${result.DAY_30_VALUE}')),
          DataCell(Text('${result.DAY_31_VALUE}')),
        ]);
  }

  @override
  int get rowCount => _results.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

}
