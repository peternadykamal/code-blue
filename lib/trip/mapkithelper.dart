
import 'package:maps_toolkit/maps_toolkit.dart';

class MapKitHelper{

  static double getMarkerRotation( sourceLat, sourceLng , destLat, destLng){



    var rotation = SphericalUtil.computeHeading(
        LatLng(sourceLat, sourceLng),
        LatLng(destLat, destLng),
    );

    return rotation.toDouble() ;
  }

  static double calculateDistance ( startPointLat ,startPointLng, endPointLat,endPointLng ){

    var distance = SphericalUtil.computeDistanceBetween(
        LatLng(startPointLat, startPointLng),
        LatLng(endPointLat, endPointLng),


    );

    return distance.toDouble();




  }

}