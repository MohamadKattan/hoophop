import 'package:hoophop/modle/nearbyAvilbleDriver.dart';

class GeoFireAssistant{

 static  List <NearByAvilbleDriver> nearByAvilbleDriverList = [];

 static void removeDriverFromList (String key){
 int index = nearByAvilbleDriverList.indexWhere((element) => element.key==key);
 nearByAvilbleDriverList.removeAt(index);
 }

 static void updataDriverLoction(NearByAvilbleDriver driver){
   int index = nearByAvilbleDriverList.indexWhere((element) => driver.key==driver.key);
  nearByAvilbleDriverList[index].latitude=driver.latitude;
   nearByAvilbleDriverList[index].longitude=driver.longitude;
 }
}