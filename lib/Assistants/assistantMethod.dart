//this class for got current position from geolocatre and use with json jecoding
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hoophop/Assistants/requestAssistant.dart';
import 'package:hoophop/configMap.dart';
import 'package:hoophop/modle/address.dart';
import 'package:hoophop/provider/appData.dart';
import 'package:provider/provider.dart';

class AssistantMethod {
  static Future<String> searchCoordinateAddress(
      Position position, BuildContext context) async {
    String placeAddress = '';
    String st1, st2, st3, st4;
    String url = // first we puted data from position in url response
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';
    var response = await RequestAssistant.getRequest(
        url); //call from RequestAssistant class
    if (response != 'failed') {
      // placeAddress = response["results"][0]["formatted_address"];
      // use jeson
      st1 = response["results"][0]["address_components"][3]["long_name"];
      st2 = response["results"][0]["address_components"][4]["long_name"];
      st2 = response["results"][0]["address_components"][5]["long_name"];
      st2 = response["results"][0]["address_components"][6]["long_name"];
      placeAddress = st1 + "," + st2 + "," + st3 + "," + st4;
      // now save data in modle Address
      Address pickUpUserAddress = Address();
      pickUpUserAddress.longitude = position.longitude;
      pickUpUserAddress.latitude = position.latitude;
      pickUpUserAddress.placeName = placeAddress;
      // now we will update to provider class (AppData)
      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocation(pickUpUserAddress);
    }
    return placeAddress; // address ready for use in google map
  }
}
