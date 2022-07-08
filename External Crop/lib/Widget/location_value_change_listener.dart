import 'package:flutter/cupertino.dart';

class LocationValueChangeListener extends ChangeNotifier {

  bool isChanged = false;

  LocationValueChangeListener() {
    isChanged = true;
    notifyListeners();
  }

  bool get counter{
    return isChanged ;
  }
}