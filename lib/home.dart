import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_project_uber_clone/Global/global_var.dart';
import 'package:test_project_uber_clone/Services/auth.dart';
import 'package:test_project_uber_clone/authentication/singup_screen.dart';
import 'package:test_project_uber_clone/authentication/login_screen.dart';
import 'package:test_project_uber_clone/methods/CommonMethods.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //create a obj from Authservice
  final Completer<GoogleMapController> GoogleMapCompleterController = Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;
  Position? currentPositionOfUser;
  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  CommonMethods cMethods = CommonMethods();
  AuthServices _auth = AuthServices();
  double searchContainerHeight = 276;
  double bottumMapPadding = 0;

  void updateMapTheme(GoogleMapController controller) {
    getJsonFileFromThemes('Themes/standard_style.json').then((value) => setGoogleMapStyle(value, controller));
  }

  Future<String> getJsonFileFromThemes(String mapStylePath) async {
    ByteData byteData = await rootBundle.load(mapStylePath);
    var list = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    return utf8.decode(list);
  }

  setGoogleMapStyle(String googleMapStyle, GoogleMapController controller) {
    // ignore: deprecated_member_use
    controller.setMapStyle(googleMapStyle);
  }

  getCurrentLiveLocationOfUser() async {
    Position positionOfUser = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPositionOfUser = positionOfUser;
    LatLng positionOfUserInLatLng = LatLng(currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);
    CameraPosition cameraPosition = CameraPosition(target: positionOfUserInLatLng, zoom: 15);
    controllerGoogleMap!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    await getUserInfoAndCheckBlockStatus();
  }

  getUserInfoAndCheckBlockStatus() async {
    DatabaseReference usersref = FirebaseDatabase.instance.ref().child('users').child(FirebaseAuth.instance.currentUser!.uid);
    await usersref.once().then((snap) {
      if (snap.snapshot.value != null) {
        if ((snap.snapshot.value as Map)["blockStatus"] == "no") {
          setState(() {
            userName = (snap.snapshot.value as Map)["name"];
          });
        } else {
          _auth.SignOut();
          Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
          cMethods.displaySnackbar("You are blocked by admin", context);
        }
      } else {
        _auth.SignOut();
        cMethods.displaySnackbar("Problem occured. Please try again", context);
        Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: sKey,
        // appBar: AppBar(
        //   title: const Text("HOME"),
        // ),
        drawer: Container(
          width: 255,
          color: Colors.black87,
          child: Drawer(
            backgroundColor: Colors.white10,
            child: ListView(
              children: [
                //header
                Container(
                  color: Colors.black12,
                  height: 160,
                  child: DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          "assests/images/avatarwoman.webp",
                          width: 60,
                          height: 60,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Profile",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ), // TextStyle
                          ), // Text
                        ])
                      ],
                    ),
                  ),
                ),

                //divider
                const Divider(
                  height: 1,
                  color: Colors.white,
                  thickness: 1,
                ),

                const SizedBox(
                  height: 10,
                ),

                //body
                ListTile(
                  leading: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.info,
                      color: Colors.grey,
                    ),
                  ),
                  title: Text(
                    "About",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),

                GestureDetector(
                  child: ListTile(
                    onTap: () async {
                      await _auth.SignOut();
                      Navigator.push(context, MaterialPageRoute(builder: (c) => SignUpScreen()));
                    },
                    leading: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.grey,
                      ),
                    ),
                    title: Text(
                      "Logout",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
                padding: EdgeInsets.only(top: 25, bottom: bottumMapPadding),
                initialCameraPosition: googlePlexInitialPosition,
                mapType: MapType.normal,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
                // polylines: polylineset,
                // markers: narker,
                onMapCreated: (GoogleMapController mapController) {
                  controllerGoogleMap = mapController;
                  updateMapTheme(controllerGoogleMap!);
                  GoogleMapCompleterController.complete(controllerGoogleMap);
                  setState(() {
                    bottumMapPadding = 110;
                  });
                  getCurrentLiveLocationOfUser();
                }),
            //drawer button
            Positioned(
                top: 42,
                left: 19,
                child: GestureDetector(
                  onTap: () {
                    sKey.currentState!.openDrawer();
                  },
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      )
                    ]),
                    child: const CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 20,
                      child: Icon(
                        Icons.menu,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                )),

            //search location icon button
            Positioned(
              left: 0,
              right: 0,
              bottom: -80,
              child: Container(
                height: searchContainerHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, shape: const CircleBorder(), padding: const EdgeInsets.all(24)),
                        child: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 25,
                        )),
                    ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, shape: const CircleBorder(), padding: const EdgeInsets.all(24)),
                        child: const Icon(
                          Icons.home,
                          color: Colors.white,
                          size: 25,
                        )),
                    ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, shape: const CircleBorder(), padding: const EdgeInsets.all(24)),
                        child: const Icon(
                          Icons.work,
                          color: Colors.white,
                          size: 25,
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
