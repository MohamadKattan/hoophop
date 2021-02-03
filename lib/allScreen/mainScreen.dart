import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hoophop/widget/divider.dart';

class MainScreen extends StatefulWidget {
  static const String screenId = 'MainScreen';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController
      newGoogleMapController; // when rider want a driver for change map
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('HoopHop', style: TextStyle(color: Colors.yellowAccent)),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
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
                    blurRadius:16.0,
                    spreadRadius:0.5,
                    offset: Offset(0.7,0.7)
                  ),
                ],
              ),
              child: Padding(padding: EdgeInsets.only(left: 18.0),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.0,),
                  Text('Hi there',style: TextStyle(color: Colors.black,fontSize: 16.0)),
                  Text('Where to ?',style: TextStyle(color: Colors.black,fontSize: 14.0)),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Icon(Icons.search,color: Colors.grey,), SizedBox(height: 4.0,),
                      Text('Search drop of',style: TextStyle(color: Colors.black,fontSize: 14.0)),
                    ]),
                  SizedBox(height: 9.0,),
                  Row(
                    children: [
                      Icon(Icons.home,color: Colors.yellowAccent,),
                      Padding(
                        padding:  EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Text('Add home',style: TextStyle(color: Colors.black,fontSize: 16.0)),
                          Text('your address home',style: TextStyle(color: Colors.grey,fontSize: 14.0)),
                        ],),
                      )

                    ],

                  ),
                  SizedBox(height: 9.0,),
                  DivederWidget(),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Icon(Icons.work,color: Colors.yellowAccent,),
                      SizedBox(height: 4.0,),
                      Padding(
                        padding:  EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Text('Add work',style: TextStyle(color: Colors.black,fontSize: 16.0)),
                          Text('your address office',style: TextStyle(color: Colors.grey,fontSize: 14.0)),
                        ],),
                      )

                    ],

                  ),
                  SizedBox(height: 9.0,),
                  DivederWidget(),





              ],)
                ,),
            ),
          ),
        ],
      ),
    );
  }
}
