// this class for listing to chancing data gecoding
import 'package:flutter/cupertino.dart';
import 'package:hoophop/modle/address.dart';

class AppData extends ChangeNotifier {
  Address pickUpLoction;
  void updatePickUpLocation(Address pickUPAddress) {
    pickUpLoction = pickUPAddress;
    notifyListeners();
  }
}
