

import 'package:gradproject/trip/nearbydriver.dart';

class FireHelper{

  static List<NearbyDriver> nearbyDriverList = [];

  static void removeFromList (String key ) {

    int index = nearbyDriverList.indexWhere((element) => element.key == key);
     nearbyDriverList.removeAt(index);

  }

  static void updateNearbyLocation(NearbyDriver driver){

    int index = nearbyDriverList.indexWhere((element) => element.key == driver.key);
    nearbyDriverList[index].longitude = driver.longitude ;
    nearbyDriverList[index].latitude = driver.latitude ;

  }









}