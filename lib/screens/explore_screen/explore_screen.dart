import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:e_commerce_ml/const.dart';
import 'package:e_commerce_ml/screens/chat_screen/message_screen.dart';
import 'package:e_commerce_ml/screens/sell_screen/location_selection_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import '../../models/advert_model.dart';
import '../my_listings_screen/detailed_listing.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final Completer<ui.Image> completer1 = Completer();
  final Completer<ui.Image> completer3 = Completer();

  List<String> advertsUniqueLocations = [];
  List<Advert> adverts = [];
  List<LatLng> advertLocations = [];
  List<Uint8List> advertsImages = [];
  Set<Marker> markers = {};
  ScrollController scrollController = ScrollController();
  LatLng? currentPosition;
  double _sheetPosition = 0.4;
  bool isLoading = false;
  int selectedIndex = 15;
  int subSelectedIndex = 25;
  List<String>? listToShow = [];
  final locationController = Location();
  BitmapDescriptor pinLocationIcon = BitmapDescriptor.defaultMarker;
  DraggableScrollableController draggableScrollableController =
      DraggableScrollableController();
  Advert advertToShowDetails = Advert();
  bool showAdvertDetails = false;
  bool showFilteredAdverts = false;
  List<Advert> filteredAdverts = [];

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.739077007885776, 29.10009918133341),
    zoom: 18,
  );

  @override
  void initState() {
    getAdverts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    for (var element in markers) {
      log(element.zIndex.toString());
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          heroTag: "123",
          onPressed: () {
            goToCurrentLocation();
          },
          backgroundColor: Colors.grey.shade200,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: isLoading != true
              ? const Icon(Icons.location_searching_rounded)
              : const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                height: constraints.maxHeight * 0.85,
                child: GoogleMap(
                  mapToolbarEnabled: true,
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  markers: markers,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              );
            },
          ),
          draggableScrollableSheetBuilder(showAdvertDetails)
        ],
      ),
    );
  }

  DraggableScrollableSheet draggableScrollableSheetBuilder(
      bool showAdvertDetail) {
    return DraggableScrollableSheet(
      shouldCloseOnMinExtent: false,
      minChildSize: 0.15,
      controller: draggableScrollableController,
      maxChildSize: 1,
      initialChildSize: _sheetPosition,
      builder: (context, scrollController) {
        if (showAdvertDetail) {
          return advertDetail(scrollController, context);
        } else if (showFilteredAdverts) {
          return filteredAdvert(scrollController, context);
        } else {
          return advertCategories(scrollController);
        }
      },
    );
  }

  Container advertCategories(ScrollController scrollController) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
        child: ListView.separated(
            separatorBuilder: (context, index) {
              return const Divider();
            },
            controller: scrollController,
            itemCount: data.length + 1,
            itemBuilder: (context, index) {
              log(selectedIndex.toString());
              log((index - 1).toString());
              List<String> subCategories = [];
              if (index == 0) {
                return const Column(
                  children: [
                    SizedBox(
                      width: 50,
                      child: Divider(
                        thickness: 4,
                      ),
                    ),
                    Text(
                      "Kategoriler",
                      style: TextStyle(
                          color: Color(0xFF124076),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ],
                );
              }
              if (index - 1 == selectedIndex) {
                switch (selectedIndex) {
                  case 0:
                    subCategories =
                        data.entries.toList()[index - 1].value.keys.toList();
                  case 1:
                    subCategories =
                        data.entries.toList()[index - 1].value.keys.toList();

                    break;
                  case 2:
                    subCategories =
                        data.entries.toList()[index - 1].value.keys.toList();

                    break;
                  case 3:
                    subCategories =
                        data.entries.toList()[index - 1].value.keys.toList();

                    break;
                  case 4:
                    subCategories =
                        data.entries.toList()[index - 1].value.keys.toList();

                    break;
                  case 5:
                    subCategories =
                        data.entries.toList()[index - 1].value.keys.toList();

                    break;
                  case 6:
                    subCategories =
                        data.entries.toList()[index - 1].value.keys.toList();

                    break;
                  case 7:
                    subCategories =
                        data.entries.toList()[index - 1].value.keys.toList();

                    break;
                  case 8:
                    subCategories =
                        data.entries.toList()[index - 1].value.keys.toList();

                    break;
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(iconListForCategories[index - 1]),
                      trailing: const Icon(Icons.keyboard_arrow_up_rounded),
                      onTap: () {
                        setState(() {
                          selectedIndex = 15;
                        });
                      },
                      title: Text(
                        data.keys.toList()[index - 1],
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: scrollController,
                        shrinkWrap: true,
                        itemCount: subCategories.length,
                        itemBuilder: (context, index2) {
                          print(subSelectedIndex);
                          print(index2);
                          if (subSelectedIndex == index2) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  trailing: const Icon(
                                      Icons.keyboard_arrow_up_rounded),
                                  onTap: () {
                                    print(subSelectedIndex);
                                    setState(() {
                                      subSelectedIndex = 25;
                                    });

                                    print(subSelectedIndex);
                                  },
                                  title: Text(
                                    "\t${subCategories[index2]}",
                                    style: const TextStyle(
                                        fontSize: 17,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  controller: scrollController,
                                  shrinkWrap: true,
                                  itemCount: listToShow!.length,
                                  itemBuilder: (context, index3) => ListTile(
                                    onTap: () async {
                                      filteredAdverts = await firestoreService
                                          .getAdvertsByFilter(
                                              "${data.keys.toList()[index - 1]}--${subCategories[index2]}--${listToShow![index3]}");
                                      setState(() {
                                        showFilteredAdverts = true;
                                        showAdvertDetails = false;
                                      });
                                    },
                                    title: Text(
                                      "\t\t${listToShow![index3]}",
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                )
                              ],
                            );
                          } else {
                            return ListTile(
                              trailing:
                                  const Icon(Icons.keyboard_arrow_down_rounded),
                              onTap: () {
                                print(subSelectedIndex);
                                setState(() {
                                  subSelectedIndex = index2;

                                  listToShow = data.entries
                                      .toList()[index - 1]
                                      .value
                                      .entries
                                      .toList()[index2]
                                      .value;
                                });

                                print(listToShow);
                                print(subSelectedIndex);

                                print(listToShow);
                              },
                              title: Text(
                                "\t${subCategories[index2]}",
                                style: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          }
                        })
                  ],
                );
              }

              return ListTile(
                trailing: const Icon(Icons.keyboard_arrow_down),
                leading: Icon(iconListForCategories[index - 1]),
                enabled: true,
                title: Text(
                  data.keys.toList()[index - 1],
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  setState(() {
                    selectedIndex = index - 1;
                  });
                  print("merhaba");
                },
              );
            }),
      ),
    );
  }

  Container filteredAdvert(
      ScrollController scrollController, BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            SizedBox(
              width: 50,
              child: Divider(
                thickness: 4,
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: const Color(0xFF124076),
                        borderRadius: BorderRadius.circular(100)),
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            showAdvertDetails = false;
                            showFilteredAdverts = false;
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: Colors.white,
                        )),
                  ),
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height - 100,
              color: Colors.white,
              child: GridView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: MediaQuery.of(context).size.height / 2.7,
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(
                      splashColor: Colors.grey,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailedListing(
                                    advert: filteredAdverts[index])));
                      },
                      child: Container(
                        color: Colors.white,
                        child: Column(children: [
                          Expanded(
                            flex: 80,
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              margin: EdgeInsets.all(20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  filteredAdverts[index].image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: Text(
                              filteredAdverts[index].advertTitle!,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: Text(
                              filteredAdverts[index].isFree == false
                                  ? "${filteredAdverts[index].price!.toString()}₺"
                                  : "Ücretsiz",
                              style: TextStyle(
                                  color: filteredAdverts[index].isFree == false
                                      ? Colors.black
                                      : Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ]),
                      ),
                    );
                  },
                  itemCount: filteredAdverts.length),
            ),
          ],
        ),
      ),
    );
  }

  Container advertDetail(
      ScrollController scrollController, BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(children: [
          Stack(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height / 1.8,
                  width: MediaQuery.of(context).size.width,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(50)),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50)),
                    child: Image.network(
                      advertToShowDetails.image!,
                      fit: BoxFit.fill,
                    ),
                  )),
              const Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 50,
                  child: Divider(
                    thickness: 4,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: 30,
                left: 20,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100)),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          showAdvertDetails = false;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: Colors.black,
                      )),
                ),
              ),
              if (FirebaseAuth.instance.currentUser!.uid !=
                  advertToShowDetails.advertiserId)
                Positioned(
                  top: 30,
                  right: 20,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100)),
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MessageScreen(
                                        senderName: FirebaseAuth
                                            .instance.currentUser!.displayName!,
                                        advertId: advertToShowDetails.advertId!,
                                        senderId: FirebaseAuth
                                            .instance.currentUser!.uid,
                                        receiverName:
                                            advertToShowDetails.advertiserName!,
                                        receiverId:
                                            advertToShowDetails.advertiserId!,
                                        advertIcon: advertToShowDetails.icon,
                                      )));
                        },
                        icon: const Icon(
                          Icons.message,
                          size: 30,
                          color: Colors.black,
                        )),
                  ),
                ),
            ],
          ),
          Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        Text(
                          advertToShowDetails.advertTitle!,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                        ),
                        const Spacer(),
                        Text(
                          advertToShowDetails.isFree == false
                              ? "${advertToShowDetails.price.toString()}₺"
                              : "Ücretsiz",
                          style: TextStyle(
                              color: advertToShowDetails.isFree == true
                                  ? Colors.green
                                  : Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Açıklama",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      advertToShowDetails.description!,
                      style: TextStyle(fontSize: 17, color: Colors.grey[500]),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Ürün durumu",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(advertToShowDetails.status!,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey[500],
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Satıcı",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(advertToShowDetails.advertiserName!,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey[500],
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                  ]),
            ),
          ),
        ]),
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

  Future<String> _downloadFileAsString(String downloadURL) async {
    final response = await http.get(Uri.parse(downloadURL));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to download file');
    }
  }

  Future<void> getAdverts() async {
    log("girdi");
    adverts = await firestoreService.getAdverts();
    print(adverts);
    for (var element in adverts) {
      advertsUniqueLocations.add("${element.latitude.toString()}");
    }
    print(advertLocations);
    await mergeImages(30, 12);
    createMarkers();
  }

  Future<void> createMarkers() async {
    Marker markerToBeDeleted = const Marker(markerId: MarkerId(""));
    for (var a = 0; a < adverts.length; a++) {
      if (markers.isEmpty) {
        markers.add(Marker(
            markerId: MarkerId(adverts[a].latitude.hashCode.toString() +
                adverts[a].longitude.hashCode.toString()),
            position: LatLng(adverts[a].latitude!, adverts[a].longitude!),
            icon: BitmapDescriptor.fromBytes(advertsImages[a],
                size: const Size(10, 10)),
            onTap: () async {
              setState(() {
                showAdvertDetails = true;
                advertToShowDetails = adverts[a];
              });

              draggableScrollableController.animateTo(1,
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastEaseInToSlowEaseOut);
            },
            zIndex: 0));
      } else {
        bool isLayered = false;
        for (var marker in markers) {
          isLayered = false;
          if ((marker.position.longitude - adverts[a].longitude!).abs() <
              0.00001) {
            print(adverts[a].advertTitle);
            isLayered = true;
            markerToBeDeleted = marker;

            break;
          }
        }

        if (isLayered == true) {
          print(markerToBeDeleted);
          markers.remove(markerToBeDeleted);
          print(markers.remove(markerToBeDeleted));

          markers.add(Marker(
              markerId: MarkerId(
                  markerToBeDeleted.position.latitude.hashCode.toString() +
                      markerToBeDeleted.position.longitude.hashCode.toString()),
              position: LatLng(markerToBeDeleted.position.latitude,
                  markerToBeDeleted.position.longitude),
              icon: BitmapDescriptor.fromBytes(await getBytesFromAsset(
                  "lib/assets/images/multiplelocation.png", 120)),
              onTap: () {
                List<Advert> advertsFromSameLocation = [];
                for (var i = 0; i < advertsUniqueLocations.length; i++) {
                  if ((double.parse(advertsUniqueLocations[i]) -
                              adverts[a].latitude!)
                          .abs() <
                      0.00001) {
                    advertsFromSameLocation.add(adverts[i]);
                  }
                }
                advertSelectionDialog(advertsFromSameLocation);
              },
              zIndex: isLayered == true ? 1 : 0));
        } else {
          markers.add(Marker(
              alpha: isLayered == true ? 0.7 : 1,
              markerId: MarkerId(adverts[a].latitude.hashCode.toString() +
                  adverts[a].longitude.hashCode.toString()),
              position: LatLng(adverts[a].latitude!, adverts[a].longitude!),
              icon: BitmapDescriptor.fromBytes(advertsImages[a],
                  size: const Size(10, 10)),
              onTap: () async {
                setState(() {
                  showAdvertDetails = true;
                  advertToShowDetails = adverts[a];
                });
                await Future.delayed(const Duration(milliseconds: 100));
                await draggableScrollableController.animateTo(1,
                    duration: const Duration(seconds: 1),
                    curve: Curves.fastEaseInToSlowEaseOut);
              },
              zIndex: isLayered == true ? 1 : 0));
        }
      }
    }
    if (mounted) {
      setState(() {
        markers;
      });
    }

    print(markers);
  }

  /* Future<void> createMarkerImages() async {
    Uint8List? icon;
    for (var advert in adverts) {
      if (advert.icon != null) {
        icon = base64Decode(advert.icon!);
      }
      print("fotoğraf çekiliyor");
      await screenshotController
          .captureFromWidget(
            Container(
              height: 50,
              width: 50,
              child: Stack(
                children: [
                  Image.asset(
                    "lib/assets/images/location_fee.png",
                    width: 50,
                    height: 50,
                  ),
                  if (icon != null)
                    Positioned(
                        child: Image.memory(icon, width: 25), top: 5, left: 12),
                ],
              ),
            ),
          )
          .then((value) => advertsImages.add(value));
    }
  } */

  /* void _capturePng() {
    screenshotController.capture().then((image) {
      log(image.toString());
    });
  } */

  Future<void> mergeImages(double dx, double dy) async {
    Uint8List? icon;

    ui.decodeImageFromList(base64Decode(locationIconForFee), (ui.Image img) {
      if (!completer1.isCompleted) {
        completer1.complete(img);
      }
    });

    ui.decodeImageFromList(base64Decode(locationIconForFree), (ui.Image img) {
      if (!completer3.isCompleted) {
        completer3.complete(img);
      }
    });

    for (var advert in adverts) {
      final Completer<ui.Image> completer2 = Completer();
      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder);
      if (advert.icon != null) {
        icon = base64Decode(advert.icon!);
      }
      ui.decodeImageFromList(icon!, (ui.Image img) {
        print(advert.advertId);
        completer2.complete(img);
      });

      final ui.Image locationIconWithFee = await completer1.future;
      final ui.Image categoryIcon = await completer2.future;
      final ui.Image locationIconForFree = await completer3.future;
      final ui.Image image1;
      final ui.Image image2 = categoryIcon;

      if (advert.isFree == true) {
        image1 = locationIconForFree;
      } else {
        image1 = locationIconWithFee;
      }
      canvas.drawImage(image1, Offset.zero, Paint());
      canvas.drawImage(image2, Offset(dx, dy), Paint());

      final picture = recorder.endRecording();
      final image = await picture.toImage(
          (image1.width + dx).toInt(), (image1.height + dy).toInt());

      final imageAsByte =
          await image.toByteData(format: ui.ImageByteFormat.png);
      advertsImages.add(
        imageAsByte!.buffer.asUint8List(),
      );
    }
  }

  advertSelectionDialog(List<Advert> advertList) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Container(
            height: 500,
            width: 500,
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(advertList[index].advertTitle!),
                          Container(
                              height: 35,
                              width: 35,
                              child: Image.memory(
                                  base64Decode(advertList[index].icon!)))
                        ],
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                        setState(() {
                          showAdvertDetails = true;
                          advertToShowDetails = advertList[index];
                        });
                        await Future.delayed(const Duration(milliseconds: 100));
                        await draggableScrollableController.animateTo(1,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastEaseInToSlowEaseOut);
                      });
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 25);
                },
                itemCount: advertList.length),
          ));
        });
  }
}
