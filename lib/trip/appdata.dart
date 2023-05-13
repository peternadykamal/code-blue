import 'package:flutter/cupertino.dart';
import 'package:gradproject/trip/address.dart';

class AppData extends ChangeNotifier{

  Address pickupAddress = Address();

  void updatePickupAddress(Address pickup){

    pickupAddress = pickup;
    notifyListeners();

  }


}