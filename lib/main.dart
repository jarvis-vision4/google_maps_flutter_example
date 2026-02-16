import 'dart:async';
import 'dart:ui' as ui;


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  static const CameraPosition _kinitial = CameraPosition(
    target: LatLng(16.8565435,96.1208935),
    zoom: 13,
  );

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom:14,
  );
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
  Set<Marker> markers={};
  void loadMarker()async{
    final Uint8List markerIcon = await getBytesFromAsset('assets/store.png', 50);
    final Marker marker=Marker(
        icon: BitmapDescriptor.bytes(markerIcon),
        markerId: MarkerId("1"),
        position: LatLng(16.8565435,96.1208935),
        infoWindow: InfoWindow(
          title: "Shop 1",
          snippet: "Shop 1 snippet"
        )
    );
    markers.add(marker);
    setState(() {
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    loadMarker();
    // markers.add(
    //   Marker(
    //       markerId: MarkerId("1"),
    //       position: LatLng(16.8565435,96.1208935),
    //       infoWindow: InfoWindow(
    //         title: "Marker Number 1",
    //         snippet: "Marker 1 snippet"
    //       ),
    //     onTap: (){
    //         print("Marker1 tapped");
    //     }
    //   )
    // );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(initialCameraPosition: _kinitial,mapType: MapType.terrain,onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);

        },
        markers: markers,
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: const Text('To the lake!'),
      //   icon: const Icon(Icons.directions_boat),
      // ),
    );
  }
  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}

