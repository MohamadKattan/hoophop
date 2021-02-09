import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hoophop/Assistants/assistantMethod.dart';
import 'package:hoophop/allScreen/searchScreen.dart';
import 'package:hoophop/provider/appData.dart';
import 'package:hoophop/widget/divider.dart';
import 'package:hoophop/widget/progssesDailgo.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  static const String screenId = 'MainScreen';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController
      newGoogleMapController; // when rider want a driver for change map
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  Position currentPosition;
  var geolocator = Geolocator();

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
                    Text('Mohamad Kattan',
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
          ListTile(
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
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              loctedPostion();
            },
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              height: MediaQuery.of(context).size.height * 40 / 100,
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
                        style: TextStyle(color: Colors.black, fontSize: 16.0)),
                    Text('Where to ?',
                        style: TextStyle(color: Colors.black, fontSize: 14.0)),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        var res = await Navigator.pushNamed(
                            context, SearchScreen.screenId);
                        if (res == "obtainDirection") {
                          await getPlaceDirection();
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
  }

  // this method for got current + drop off location by (Direction Api) . step 2 for starting drawing line between two address
  Future<void> getPlaceDirection() async {
    var intialPos = Provider.of<AppData>(context, listen: false)
        .pickUpLocation; //current place
    var finalPos = Provider.of<AppData>(context, listen: false)
        .dropOffLocation; //current place
    var pickUpLating = LatLng(intialPos.latitude,
        intialPos.longitude); // longitude&&latitude off pickUpLocation
    var dropOffLating = LatLng(finalPos.latitude,
        finalPos.longitude); // longitude&&latitude off drrop off
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ProgssesDailgo(
            message: "Please wait",
          );
        });
    var details = await AssistantMethod.obtainPlaceDirctionDiatels(
        pickUpLating, dropOffLating);
    Navigator.pop(context);
    print("getPlaceDirection::" + details.encodedPoints);
  }
}
