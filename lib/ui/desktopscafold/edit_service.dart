// ignore_for_file: avoid_print

import 'dart:io';
import 'package:admin_panel/models/service_list_model.dart';
import 'package:admin_panel/ui/desktopscafold/services.dart';
import 'package:admin_panel/ui/desktopscafold/singleton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../controller/service_controller.dart';

class EditService extends StatefulWidget {
  final ServiceListModel service;
  final Product product;
  const EditService({required this.service, required this.product, super.key});

  @override
  State<EditService> createState() => _EditServiceState();
}

class _EditServiceState extends State<EditService> {
  FirebaseStorage storage = FirebaseStorage.instance;
  CollectionReference serviceRef =
      FirebaseFirestore.instance.collection('services');

  List<DropdownMenuItem<String>> dropdownItems = [];
  String? selectedServiceId = '';
  String? selectedServiceName = '';
  String? productId = '';

  List<ServiceModel> services = [];
  ServiceModel? selectedService;
  String? dropdownvalue;

  final productController = TextEditingController();
  String? productImage;

  @override
  void initState() {
    selectedServiceId = widget.service.id;
    selectedServiceName = widget.service.name;
    productId = widget.product.productId;
    productController.text = widget.product.productName;
    productImage = widget.product.productImage;

    //getServices();

    // TODO: implement initState
    super.initState();
  }

  XFile? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: const Center(child: Text('Edit Services')),
          backgroundColor: Colors.grey[900],
        ),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.35,
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Upload Image:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                // productImage!.isNotEmpty?Image.network(productImage!):
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
                SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: productController,
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
                      // ignore: sized_box_for_whitespace
                      Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () async {
                            String serviceId = selectedServiceId!;
                            String serviceName = selectedServiceName!;
                            String productName = productController.text;
                            String serviceImage = selectedImage != null
                                ? await uploadFile()
                                : productImage!;
                            bool check =
                                await ServiceController().updateService(
                                    serviceId,
                                    serviceName,
                                    {
                                      'product_id': serviceId,
                                      'product_image': serviceImage,
                                      'product_name': productName
                                    },
                                    productId!);

                            if (check) {
                              Get.offAll(() => const Myservices());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[900],
                          ),
                          child: const Text('Update Service'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
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
