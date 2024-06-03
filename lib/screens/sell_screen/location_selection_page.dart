import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:e_commerce_ml/bottom_nav_bar_builder.dart';
import 'package:e_commerce_ml/const.dart';
import 'package:e_commerce_ml/models/advert_model.dart';
import 'package:e_commerce_ml/screens/services/firestore_service.dart';
import 'package:e_commerce_ml/screens/services/ml_model_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

MlModelService _mlModelService = MlModelService();
FirestoreService firestoreService = FirestoreService();
Advert _advert = Advert();

class LocationSelectionPage extends StatefulWidget {
  const LocationSelectionPage({super.key, required this.advertData});

  final Advert advertData;
  @override
  State<LocationSelectionPage> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<LocationSelectionPage> {
  ScrollController scrollController = ScrollController();
  LatLng? currentPosition;
  double _sheetPosition = 0.4;
  bool isLoading = false;
  int selectedIndex = 15;
  final locationController = Location();
  bool isLocationSelected = false;
  String emoji = "";
  String className = "";

  BitmapDescriptor pinLocationIcon = BitmapDescriptor.defaultMarker;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.739077007885776, 29.10009918133341),
    zoom: 18,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          className != "" ? className : "" /* "Satış yapacağın adresi seç" */,
          style: TextStyle(fontSize: 17),
        ),
        centerTitle: true,
        actions: [emoji != "" ? Image.memory(base64Decode(emoji)) : Text("as")],
      ),
      floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () {
                goToCurrentLocation();
              },
              heroTag: "1",
              child: isLoading != true
                  ? const Icon(Icons.location_searching_rounded)
                  : const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
            ),
            if (isLocationSelected == true)
              const SizedBox(
                height: 10,
              ),
            if (isLocationSelected == true)
              FloatingActionButton.extended(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  backgroundColor: Colors.grey.shade200,
                  onPressed: () async {
                    var modelAsString =
                        await _mlModelService.getImageAndClassNameFromServer(
                            widget.advertData.image!);
                    var modelAsJson = jsonDecode(modelAsString);

                    setState(() {
                      emoji = modelAsJson['emoji'];
                      className = modelAsJson['emojiClass'];
                    });

                    String imageUrl = await firestoreService
                        .uploadImage(widget.advertData.imageAsFile!);

                    firestoreService.createAnAdvert(_advert.toJson(Advert(
                        advertTitle: widget.advertData.advertTitle,
                        advertiserId: widget.advertData.advertiserId,
                        advertiserName: widget.advertData.advertiserName,
                        category: className,
                        description: widget.advertData.description,
                        icon: emoji,
                        image: imageUrl,
                        latitude: currentPosition?.latitude,
                        longitude: currentPosition?.longitude,
                        status: widget.advertData.status,
                        isFree: widget.advertData.isFree,
                        price: widget.advertData.price)));

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BottomNavBarBuilder(
                                  indexToJump: 0,
                                )),
                        (route) => false);
                  },
                  label: Text("İlanı yayınla"))
          ]),
      body: Stack(
        children: [
          SizedBox(
            child: GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onTap: (location) {
                setState(() {
                  currentPosition = location;
                  isLocationSelected = true;
                });
              },
              mapToolbarEnabled: true,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              markers: {
                if (currentPosition != null)
                  Marker(
                      markerId: const MarkerId("currentLocation"),
                      position: currentPosition!)
              },
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ],
      ),
    );
  }

  Marker _createMarker() {
    return Marker(
        markerId: const MarkerId("123"),
        icon: pinLocationIcon,
        position: const LatLng(37.739077007885776, 29.10009918133341));
  }

  void setCustomMapPin() async {
    setState(() {
      isLoading = true;
    });
    pinLocationIcon = BitmapDescriptor.fromBytes(
        await getBytesFromAsset("lib/assets/images/target.png", 100));

    setState(() {
      isLoading = false;
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      print("serviceenabled?");
      serviceEnabled = await locationController.requestService().then((value) {
        if (value == false) {
          setState(() {
            isLoading = false;
          });
        }
        return value;
      });
    }

    permissionGranted = await locationController.hasPermission();
    print(permissionGranted);
    if (permissionGranted == PermissionStatus.denied) {
      print("requestpermssion?");

      permissionGranted = await locationController.requestPermission();
    }
    if (permissionGranted != PermissionStatus.granted) {
      print("permissionisnt granted?");
      setState(() {
        isLoading = false;
      });
      return;
    }

    LocationData? locationData = await locationController.getLocation();

    if (locationData.latitude != null && locationData.longitude != null) {
      setState(() {
        currentPosition =
            LatLng(locationData.latitude!, locationData.longitude!);

        isLocationSelected = true;
      });
    }
  }

  Future<void> goToCurrentLocation() async {
    setState(() {
      isLoading = true;
    });
    await fetchLocationUpdates();
    final GoogleMapController controller = await _controller.future;
    if (currentPosition != null) {
      print("girdi");
      await controller
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
        zoom: 17,
      )));
    }
    setState(() {
      isLoading = false;
    });
  }
}
