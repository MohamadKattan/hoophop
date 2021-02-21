import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoophop/allScreen/logingScreen.dart';
import 'package:hoophop/allScreen/mainScreen.dart';
import 'package:hoophop/allScreen/registeration.dart';
import 'package:hoophop/allScreen/searchScreen.dart';
import 'package:hoophop/provider/appData.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hoop Hop',
        initialRoute:FirebaseAuth.instance.currentUser == null? LoginScreen.screenId:MainScreen.screenId,
        routes: {
          RegistrationScreen.screenId: (context) => RegistrationScreen(),
          MainScreen.screenId: (context) => MainScreen(),
          LoginScreen.screenId: (context) => LoginScreen(),
          SearchScreen.screenId: (context) => SearchScreen(),
        },
      ),
    );
  }
}
