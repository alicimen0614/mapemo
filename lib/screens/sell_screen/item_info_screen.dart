import 'dart:convert';
import 'dart:io';

import 'package:e_commerce_ml/bottom_nav_bar_builder.dart';
import 'package:e_commerce_ml/models/advert_model.dart';
import 'package:e_commerce_ml/screens/sell_screen/location_selection_page.dart';
import 'package:e_commerce_ml/screens/services/auth_service.dart';
import 'package:e_commerce_ml/screens/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

FirestoreService _firestoreService = FirestoreService();

class ItemInfoScreen extends StatefulWidget {
  const ItemInfoScreen({super.key});

  @override
  State<ItemInfoScreen> createState() => _ItemInfoScreenState();
}

class _ItemInfoScreenState extends State<ItemInfoScreen> {
  bool isImageSizeSuitable = false;
  File? pickedImage;
  Uint8List? imageAsByte;

  TextEditingController statusController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  final formkey = GlobalKey<FormState>();
  bool isFree = false;

  @override
  Widget build(BuildContext context) {
    String status = "";
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formkey,
            child: Column(children: [
              Container(
                decoration: BoxDecoration(
                    color:
                        imageAsByte != null ? Colors.transparent : Colors.grey,
                    image: imageAsByte != null
                        ? DecorationImage(
                            image: MemoryImage(imageAsByte!),
                            fit: BoxFit.fitHeight)
                        : null),
                width: imageAsByte == null
                    ? MediaQuery.of(context).size.width / 2
                    : MediaQuery.of(context).size.width / 1.2,
                height: imageAsByte == null
                    ? MediaQuery.of(context).size.height / 3
                    : MediaQuery.of(context).size.height / 2.5,
                child: imageAsByte == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            IconButton(
                              icon: const Icon(
                                Icons.camera_alt_outlined,
                                size: 50,
                              ),
                              onPressed: () {
                                modalBottomSheetBuilderForPopUpMenu(context);
                              },
                            ),
                            const Text(
                              "Bir fotoğraf ekle",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            )
                          ])
                    : null,
              ),
              TextFormField(
                autofocus: false,
                controller: statusController,
                readOnly: true,
                onTap: () {
                  showStatusSelectionDialog(context, status);
                },
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Durum*',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Bu  alan boş bırakılamaz";
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'İlan başlığı*',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Bu alan boş bırakılamaz";
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'İlan açıklaması*',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Bu alan boş bırakılamaz";
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                enabled: !isFree,
                controller: priceController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Fiyat*',
                ),
                validator: (value) {
                  if (value!.isEmpty && isFree == false) {
                    return "Bu alan boş bırakılamaz";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text("Ücretsiz vermek istiyorum."),
                  Checkbox(
                      value: isFree,
                      onChanged: (newValue) {
                        setState(() {
                          priceController.clear();
                          isFree = newValue!;
                        });
                      }),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      if (imageAsByte != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LocationSelectionPage(
                                    advertData: Advert(
                                        advertTitle: titleController.text,
                                        advertiserId: authService.getUserId,
                                        advertiserName: authService
                                                .currentUser!.displayName ??
                                            "",
                                        category: "",
                                        description: descriptionController.text,
                                        image: imageAsByte != null
                                            ? base64Encode(imageAsByte!)
                                            : "",
                                        imageAsFile: pickedImage,
                                        status: statusController.text,
                                        icon: "",
                                        latitude: null,
                                        longitude: null,
                                        isFree: isFree,
                                        price: double.tryParse(
                                            priceController.text)))));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Lütfen bir fotoğraf ekleyiniz")));
                      }
                    }
                  },
                  child: Text(
                    "Sonraki",
                    style: TextStyle(color: Colors.white),
                  ))
            ]),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showStatusSelectionDialog(
      BuildContext context, String status) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Bir durum seçin",
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
                ListTile(
                  title: const Text("Yeni"),
                  onTap: () {
                    setState(() {
                      status = "Yeni";
                      statusController.text = "Yeni";
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Yeni gibi"),
                  onTap: () {
                    setState(() {
                      status = "Yeni gibi";
                      statusController.text = "Yeni gibi";
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                    title: const Text("İyi"),
                    onTap: () {
                      setState(() {
                        status = "İyi";
                        statusController.text = "İyi";
                      });
                      Navigator.pop(context);
                    }),
                ListTile(
                    title: const Text("Makul"),
                    onTap: () {
                      setState(() {
                        status = "Makul";
                        statusController.text = "Makul";
                      });
                      Navigator.pop(context);
                    }),
                ListTile(
                    title: const Text("Yıpranmış"),
                    onTap: () {
                      setState(() {
                        status = "Yıpranmış";
                        statusController.text = "Yıpranmış";
                      });
                      Navigator.pop(context);
                    }),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("İptal")),
                ),
              ],
            ),
          );
        });
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (image == null) {
        return;
      } else {
        final CroppedFile? croppedFile =
            await cropImage(file: image).whenComplete(() {
          Navigator.pop(context);
        });

        if (croppedFile != null) {
          isImageSizeSuitable = true;
          imageAsByte = await croppedFile.readAsBytes();
          setState(() {});

          setState(() {
            pickedImage = File(croppedFile.path);
          });
        }
      }
    } on PlatformException {}
  }

  Future<CroppedFile?> cropImage({required XFile file}) async {
    return await ImageCropper().cropImage(
      sourcePath: file.path,
      uiSettings: [AndroidUiSettings(lockAspectRatio: false)],
    );
  }

  Future<int> checkImageSize(File image) async {
    Uint8List imageAsByte = await image.readAsBytes();
    String base64Data = base64Encode(imageAsByte);
    int base64Size = base64Data.length;
    print(base64Size);

    return base64Size;
  }

  void modalBottomSheetBuilderForPopUpMenu(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.grey.shade300,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      context: context,
      builder: (context) {
        return Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            visualDensity: const VisualDensity(vertical: 3),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            onTap: () {
              pickImage(ImageSource.camera);
            },
            leading: const Icon(
              color: Colors.black,
              Icons.photo_camera_outlined,
              size: 30,
            ),
            title: const Text("Kamera", style: TextStyle(fontSize: 20)),
          ),
          const Divider(
            height: 0,
          ),
          ListTile(
            visualDensity: const VisualDensity(vertical: 3),
            onTap: () => pickImage(ImageSource.gallery),
            leading: const Icon(
              Icons.image_outlined,
              color: Colors.black,
              size: 30,
            ),
            title: const Text("Galeri", style: TextStyle(fontSize: 20)),
          ),
        ]);
      },
    );
  }
}
