// ignore_for_file: avoid_print, avoid_unnecessary_containers, sized_box_for_whitespace

import 'dart:io';

import 'package:admin_panel/ui/desktopscafold/services.dart';
import 'package:admin_panel/ui/desktopscafold/singleton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../controller/service_controller.dart';

class Addservice extends StatefulWidget {
  const Addservice({super.key});

  @override
  State<Addservice> createState() => _AddserviceState();
}

class _AddserviceState extends State<Addservice> {
  FirebaseStorage storage = FirebaseStorage.instance;
  CollectionReference serviceRef =
      FirebaseFirestore.instance.collection('services');

  List<DropdownMenuItem<String>> dropdownItems = [];
  String? selectedServiceId = '';

  List<ServiceModel> services = [];
  ServiceModel? selectedService;
  String? dropdownvalue;

  final categoryController = TextEditingController();

  @override
  void initState() {
    //getServices();

    // TODO: implement initState
    super.initState();
  }

  Future<List<ServiceModel>> getServices() async {
    services.clear();
    QuerySnapshot snapshot = await serviceRef.get();
    //dropdownvalue=snapshot.docs.first.id;
    for (var doc in snapshot.docs) {
      print(doc.id);

      services.add(ServiceModel(doc.id, doc.get('name')));
    }

    Singleton.instance.selectedService = services.first;
    Singleton.instance.selectedIndex = services.first.id;

    return services;
  }

  final _serviceController = TextEditingController();
  XFile? selectedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Center(child: Text('Add Services')),
        backgroundColor: Colors.grey[900],
      ),
      body: FutureBuilder(
          future: getServices(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("error in koadinb data");
            }
            if (snapshot.hasData) {
              return Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Upload Image:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      selectedImage != null
                          ? SizedBox(
                              height: 200,
                              width: 200,
                              child: Image.network(selectedImage!.path))
                          : InkWell(
                              onTap: () async {
                                final ImagePicker picker = ImagePicker();

                                final XFile? image = await picker.pickImage(
                                    source: ImageSource.gallery);

                                //  final XFile? photo = await picker.pickImage(source: ImageSource.camera);

                                if (kIsWeb) {
                                  Image.network(image!.path);
                                  setState(() {
                                    selectedImage = image;
                                  });
                                } else {
                                  Image.file(File(image!.path));
                                  setState(() {
                                    selectedImage = image;
                                  });
                                }
                              },
                              child: Container(
                                height: 200,
                                width: 200,
                                color: Colors.white,
                                child: const Center(
                                  child: Text('Select Image'),
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Select category:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        //alignment: Alignment.center,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, item) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    Singleton.instance.selectedIndex =
                                        snapshot.data![item].id;
                                    selectedServiceId = snapshot.data![item].id;
                                    Singleton.instance.selectedService =
                                        snapshot.data![item];
                                    print(Singleton.instance.selectedIndex);
                                    print(Singleton
                                        .instance.selectedService?.serviceName);
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: selectedServiceId ==
                                                  snapshot.data![item].id
                                              ? Colors.blue
                                              : Colors.white),
                                      color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                        Text(snapshot.data![item].serviceName),
                                  ),
                                ),
                              );
                            }),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: _serviceController,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                hintText: 'Enter Services Name',
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: ElevatedButton(
                                onPressed: () async {
                                  String serviceId = createIdFromDateTime();
                                  // ignore: unused_local_variable
                                  String category = selectedServiceId!;
                                  String serviceName = _serviceController.text;
                                  String serviceImage = await uploadFile();
                                  bool check = await ServiceController()
                                      .addService(
                                          Singleton.instance.selectedService!, {
                                    'product_id': serviceId,
                                    'product_image': serviceImage,
                                    'product_name': serviceName
                                  });
                                  if (check) {
                                    Fluttertoast.showToast(
                                        msg: "Service added Successfully!");
                                    Get.offAll(() => const Myservices());
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[900],
                                ),
                                child: const Text('Save Service'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }

  Future<void> saveData(Map<String, dynamic> productData) async {
    try {
      CollectionReference serviceRef =
          FirebaseFirestore.instance.collection('services');
      DocumentReference serviceDocRef =
          serviceRef.doc(Singleton.instance.selectedService!.id);
      DocumentSnapshot documentSnapshot = await serviceDocRef.get();
      if (documentSnapshot.exists) {
        // documentSnapshot.get(field)
        FieldPath fieldPath = FieldPath(const ['product']);
        List<dynamic> existingProducts =
            documentSnapshot.get(fieldPath) as List<dynamic>;
        List<dynamic> updatedProducts = [...existingProducts, productData];

        await serviceDocRef.set({
          'id': Singleton.instance.selectedService!.id,
          'name': Singleton.instance.selectedService!.serviceName,
          'product': updatedProducts
        });
      }

      // await serviceDocRef.set({'products': productData});
    } catch (e) {
      print('Error: $e');
    }
  }

  String createIdFromDateTime() {
    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat('yyyyMMddHHmmss').format(now);
    return formattedDateTime;
  }

  Future<String> uploadFile() async {
    Uint8List bytes = await selectedImage!.readAsBytes();

    Reference ref = storage.ref().child('${DateTime.now()}.png');
    UploadTask uploadTask =
        ref.putData(bytes, SettableMetadata(contentType: 'image/png'));
    TaskSnapshot taskSnapshot = await uploadTask
        .whenComplete(() => print('done'))
        // ignore: invalid_return_type_for_catch_error
        .catchError((error) => print('something went wrong'));
    String url = await taskSnapshot.ref.getDownloadURL();
    print("url: $url");
    return url;
  }
}

class ServiceModel {
  final String id;
  final String serviceName;

  ServiceModel(this.id, this.serviceName);
}
