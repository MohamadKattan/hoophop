import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hoophop/Assistants/assistantMethod.dart';
import 'package:hoophop/Assistants/geoFireassistant.dart';
import 'package:hoophop/allScreen/logingScreen.dart';
import 'package:hoophop/allScreen/searchScreen.dart';
import 'package:hoophop/modle/allUsers.dart';
import 'package:hoophop/modle/directionDetails.dart';
import 'package:hoophop/modle/nearbyAvilbleDriver.dart';
import 'package:hoophop/provider/appData.dart';
import 'package:hoophop/widget/divider.dart';
import 'package:hoophop/widget/progssesDailgo.dart';
import 'package:provider/provider.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MainScreen extends StatefulWidget {
  static const String screenId = 'MainScreen';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController
      newGoogleMapController; // when rider want a driver for change map
  static final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962), zoom: 14.4746);

  Position currentPosition;
  var geolocator = Geolocator();

// for line between two address
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> plineCoordinates = [];
  Set<Polyline> polylineSet = {};
  Set<Marker> markersSet = {};
  Set<Circle> circleSet = {};
// fo switch between addressSearchContainer && requistAtexiContainer
  double addressSearchContainer = 300.0;
  double requistAtexiContainer = 0.0;
  double bottonPaddingOfMap = 340;
  double textContainerFindAdriver = 0.0;

  DirectionDetails tripDirectionDetails;

  DatabaseReference riderRequestRef;
  Users _users = Users();

  bool isdriverlocded = false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AssistantMethod.getCurrentonlineUserInfo(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('HoopHop', style: TextStyle(color: Colors.yellowAccent)),
      ),
      drawer: Container(
        width: MediaQuery.of(context).size.width * 70 / 100,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.white,
                blurRadius: 6.0,
                spreadRadius: 0.5,
                offset: Offset(0.7, 0.7)),
          ],
        ),
        child: Drawer(
            child: ListView(children: [
          Container(
              height: 165.0,
              decoration: BoxDecoration(
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7)),
                ],
              ),
              child: DrawerHeader(
                  child: Row(children: [
                CircleAvatar(
                    backgroundColor: Colors.yellowAccent,
                    child: Icon(Icons.person)),
                SizedBox(
                  width: 9.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name:',
                      style:
                          TextStyle(color: Colors.yellowAccent, fontSize: 16),
                    ),
                    Text("mohamad",
                        style:
                            TextStyle(color: Colors.yellowAccent, fontSize: 14))
                  ],
                )
              ]))),
          ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.black,
                radius: 15,
                child: Icon(
                  Icons.history,
                  color: Colors.yellowAccent,
                )),
            title: Text('My History '),
            tileColor: Colors.white,
          ),
          DivederWidget(),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.black,
                radius: 15,
                child: Icon(
                  Icons.person,
                  color: Colors.yellowAccent,
                )),
            title: Text('My Profile '),
            tileColor: Colors.white,
          ),
          DivederWidget(),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.black,
                radius: 15,
                child: Icon(
                  Icons.info,
                  color: Colors.yellowAccent,
                )),
            title: Text('About us '),
            tileColor: Colors.white,
          ),
          DivederWidget(),
          SizedBox(height: 20),
          GestureDetector(
            onTap: ()=>singOut(),
            child: ListTile(
              leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 15,
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.yellowAccent,
                  )),
              title: Text('SignOut '),
              tileColor: Colors.white,
              subtitle: Text(
                'See you soon',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          DivederWidget(),
          SizedBox(
            height: 10,
          ),
        ])),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            polylines: polylineSet,
            markers: markersSet,
            circles: circleSet,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              setState(() {
                bottonPaddingOfMap = 300;
              });
              loctedPostion();
            },
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: AnimatedSize(
              vsync: this,
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),
              child: Container(
                height: addressSearchContainer,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      topLeft: Radius.circular(20.0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 16.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7)),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 4.0,
                      ),
                      Text('Hi there',
                          style:
                              TextStyle(color: Colors.black, fontSize: 16.0)),
                      Text('Where to ?',
                          style:
                              TextStyle(color: Colors.black, fontSize: 14.0)),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (Provider.of<AppData>(context,listen: false).pickUpLocation !=
                              null) {
                            var res = await Navigator.pushNamed(
                                context, SearchScreen.screenId);
                            if (res == "obtainDirection") {
                              switchIfAddreesOrRequistContainer();
                            }
                          } else {
                            Fluttertoast.showToast(msg: "Restart app & Turn GPS",backgroundColor: Colors.redAccent[700]);
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20.0),
                                  topLeft: Radius.circular(20.0)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 16.0,
                                    spreadRadius: 0.5,
                                    offset: Offset(0.7, 0.7)),
                              ],
                            ),
                            child: Row(children: [
                              Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text('Search drop of',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14.0)),
                            ]),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 9.0,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.home,
                            color: Colors.yellowAccent,
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    Provider.of<AppData>(context)
                                                .pickUpLocation !=
                                            null
                                        ? Provider.of<AppData>(context)
                                            .pickUpLocation
                                            .placeName
                                        : 'Add home',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16.0)),
                                Text('your address home',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14.0)),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 9.0,
                      ),
                      DivederWidget(),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.work,
                            color: Colors.yellowAccent,
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Add work',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16.0)),
                                Text('your address office',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14.0)),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 9.0,
                      ),
                      DivederWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0.0,
            left: 0.0,
            bottom: 0.0,
            child: AnimatedSize(
              vsync: this,
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),
              child: Container(
                height: requistAtexiContainer,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16.0),
                        topLeft: Radius.circular(16.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white,
                          blurRadius: 6.0,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7))
                    ]),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Icon(FontAwesomeIcons.taxi,
                                  color: Colors.black, size: 35.0),
                              SizedBox(
                                width: 10.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'By a car',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18.0),
                                  ),
                                  Text(
                                      (tripDirectionDetails != null)
                                          ? tripDirectionDetails.distanceText
                                          : "km",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16.0)),
                                ],
                              ),
                              Expanded(child: Container()),
                              Text((tripDirectionDetails != null)
                                  ? "\$${AssistantMethod.calcuttaFares(tripDirectionDetails)}"
                                  : "")
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.moneyBillAlt,
                              color: Colors.black54,
                              size: 18.0,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              "Cash",
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Icon(Icons.keyboard_arrow_down,
                                color: Colors.black54, size: 16.0),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: RaisedButton(
                          onPressed: () {
                        switchIfWatingAdriverOrRequistContainer();
                          },
                          padding: EdgeInsets.all(17.0),
                          color: Theme.of(context).accentColor,
                          child: Center(
                              child: Text("Request a taxi",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0))),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: RaisedButton(
                          animationDuration: Duration(milliseconds: 300),
                          onPressed: () {
                            restApp();
                          },
                          padding: EdgeInsets.all(17.0),
                          color: Colors.redAccent,
                          child: Center(
                              child: Text("Cancel order",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0.0,
            left: 0.0,
            bottom: 0.0,
            child: AnimatedSize(
              vsync: this,
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),
              child:Container(
                width: double.infinity,
                height:textContainerFindAdriver ,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16.0),
                        topLeft: Radius.circular(16.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white,
                          blurRadius: 6.0,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7))
                    ]),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(children: [
                  SizedBox(height: 5.0,),
                  SizedBox(
                    width: 250.0,
                    child: ColorizeAnimatedTextKit(
                      onTap: () {
                        print("Tap Event");
                      },
                      text: [
                        "please wait",
                        "trying to ",
                        "find a driver",
                      ],
                      textStyle: TextStyle(
                          fontSize: 33.0,
                          fontFamily: "Horizon",
                        color: Colors.grey
                      ),
                      colors: [
                        Colors.black12,
                        Colors.black26,
                        Colors.black38,
                        Colors.black54,
                      ],
                      textAlign: TextAlign.center,
                    ),
                  ),
                    SizedBox(height: 15.0,),
                    GestureDetector(
                      onTap:(){
                        cancleRiderRequest();
                        restApp();
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25.0),
                            border: Border.all(width: 2.0,color: Colors.black54),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 6.0,
                                  spreadRadius: 0.5,
                                  offset: Offset(0.7, 0.7))
                            ]),
                        child: Icon(Icons.close,size: 25,),
                        ),
                    ),
                    SizedBox(height: 5.0,),
                    Center(child: Text("Cancel",))

                  ],),
                ),

              ),
            ),
          ),

        ],
      ),
    );
  }

  // this method for get current position
  void loctedPostion() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14.0);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String address =
        await AssistantMethod.searchCoordinateAddress(position, context);
    print(address);
    initGeoFireListener();
  }

  // this method for got current + drop off location by (Direction Api) . step 2 for starting drawing line between two address
  Future<void> getPlaceDirection() async {
    var intialPos = Provider.of<AppData>(context, listen: false)
        .pickUpLocation; //current place
    var finalPos = Provider.of<AppData>(context, listen: false)
        .dropOffLocation; //current place
    var pickUpLating = LatLng(intialPos.latitude,
        intialPos.longitude); // longitude&&latitude off pickUpLocation
    var dropOffLating = LatLng(finalPos.latitude, finalPos.longitude);
    // longitude&&latitude off drrop off
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ProgssesDailgo(
            message: "Please wait",
          );
        });
    var details = await AssistantMethod.obtainPlaceDirctionDiatels(
        pickUpLating, dropOffLating);
    setState(() {
      tripDirectionDetails = details;
    });
    Navigator.pop(context);
    print("getPlaceDirection::");
    print(details.encodedPoints);
    // for line on mape
    List<PointLatLng> pointLatLngResult =
        polylinePoints.decodePolyline(details.encodedPoints);
    plineCoordinates.clear();
    if (pointLatLngResult.isNotEmpty) {
      pointLatLngResult.forEach((PointLatLng pointLatLng) {
        plineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polylineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId("polylineId"),
        color: Colors.red,
        points: plineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      polylineSet.add(polyline);
    });
    Marker pickUpLocationMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        infoWindow:
            InfoWindow(title: intialPos.placeName, snippet: "My location"),
        position: pickUpLating,
        markerId: MarkerId("PickUpId"));
    Marker dropOffLocationMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
            title: intialPos.placeName, snippet: "Drop off location"),
        position: dropOffLating,
        markerId: MarkerId("DropOffId"));
    setState(() {
      markersSet.add(pickUpLocationMarker);
      markersSet.add(dropOffLocationMarker);
    });
    Circle pickUpCircle = Circle(
        fillColor: Colors.blueAccent,
        center: pickUpLating,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.blue,
        circleId: CircleId("PickUpId"));
    Circle droOffCircle = Circle(
        fillColor: Colors.redAccent,
        center: dropOffLating,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.red,
        circleId: CircleId("DropOffId"));
    setState(() {
      circleSet.add(pickUpCircle);
      circleSet.add(droOffCircle);
    });
  }

  // this method for switch AddreesOrRequistContainer
  void switchIfAddreesOrRequistContainer() async {
    await getPlaceDirection();
    setState(() {
      addressSearchContainer = 0.0;
      requistAtexiContainer = 240.0;
      bottonPaddingOfMap = 230.0;
    });
  }
  // this method for switch waiting a driver OrRequistContainer
  void switchIfWatingAdriverOrRequistContainer() async {
    setState(() {
      requistAtexiContainer = 0.0;
    textContainerFindAdriver = 250.0;

    });
    saveRiderRequest();
  }

  // This VOID fOR Cancel  order rider
  void restApp() {
    setState(() {
      addressSearchContainer = 300.0;
      requistAtexiContainer = 0.0;
      textContainerFindAdriver =0.0;
      bottonPaddingOfMap = 340;
      polylineSet.clear();
      markersSet.clear();
      circleSet.clear();
      plineCoordinates.clear();
    });
    loctedPostion();
  }

  // this metjod for save rider request info
void saveRiderRequest(){
    riderRequestRef =
    FirebaseDatabase.instance.reference().child("riderRequest").push();
    var pickup = Provider.of<AppData>(context,listen: false).pickUpLocation;
    var dropOff = Provider.of<AppData>(context,listen: false).dropOffLocation;
    Map riderInfoMap = {
      "driver_id":"waiting",
      "payment_method":"cash",
      "pickUpLat":pickup.latitude.toString(),
      "pickUpLon":pickup.longitude.toString(),
     "pickUpName":pickup.placeName,
      "dropOffLat":dropOff.latitude.toString(),
      "dropOffLon":dropOff.longitude.toString(),
      "dropOffName":dropOff.placeName,
      "riderName":userCurrentInfo.name,
      "riderPhone":userCurrentInfo.phone,
      "createAt":DateTime.now().toString(),
    };
    riderRequestRef.set(riderInfoMap);
 }

 // this method for delete riderRequest from database
void cancleRiderRequest(){
  riderRequestRef.remove();
}
// this method for sing out
void singOut()async{
    FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.screenId, (route) => false);

 }

// this method for rider see driver who is close to him
void initGeoFireListener(){
  Geofire.initialize("availableDrivers");
//rider currentPosition
  Geofire.queryAtLocation(currentPosition.latitude, currentPosition.longitude, 5).listen ((map) {
    print(map);
    if (map != null) {
      var callBack = map['callBack'];


// this switch for got driver currentPosition close to rider
      switch (callBack) {
        case Geofire.onKeyEntered:
          NearByAvilbleDriver nearByAvilbleDriver = NearByAvilbleDriver();

          nearByAvilbleDriver.key = map["key"];
          nearByAvilbleDriver.latitude = map["latitude"];
          nearByAvilbleDriver.longitude = map["longitude"];
          GeoFireAssistant.nearByAvilbleDriverList.add(nearByAvilbleDriver);
          if(isdriverlocded == true){
            updataAvilbleDriversOnMap();
          }

          break;

        case Geofire.onKeyExited:
          GeoFireAssistant.removeDriverFromList(map["key"]);
          updataAvilbleDriversOnMap();

          break;

        case Geofire.onKeyMoved:
        // Update your key's location
          NearByAvilbleDriver nearByAvilbleDriver = NearByAvilbleDriver();

          nearByAvilbleDriver.key = map["key"];
          nearByAvilbleDriver.latitude = map["latitude"];
          nearByAvilbleDriver.longitude = map["longitude"];
          GeoFireAssistant.updataDriverLoction(nearByAvilbleDriver);
          updataAvilbleDriversOnMap();
          break;

        case Geofire.onGeoQueryReady:
          updataAvilbleDriversOnMap();

          break;
      }
    }

    setState(() {});


  });

}
// this method when got drivers close to rider it will show markers on map
 void updataAvilbleDriversOnMap(){
   setState(() {
     markersSet.clear();
   });
  Set <Marker> tMarker = Set<Marker>();
  for(NearByAvilbleDriver driver in GeoFireAssistant.nearByAvilbleDriverList){
    LatLng driverAvaiablePosition = LatLng(driver.latitude, driver.longitude);
    Marker marker = Marker(
      markerId: MarkerId("driver${driver.key}"),
      position: driverAvaiablePosition,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      rotation: AssistantMethod.creatRandomNumber(360),
    );
    tMarker.add(marker);
   }
  setState(() {
    markersSet = tMarker;
  });
 }

}
