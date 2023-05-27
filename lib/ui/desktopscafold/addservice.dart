import 'dart:io';

import 'package:admin_panel/ui/desktopscafold/singleton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart';



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
  String? selectedServiceId='';

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
     // print(doc);
    //  print(doc.get('name'));
      // Create a DropdownMenuItem and add it to the list
      services.add(ServiceModel(doc.id,doc.get('name')));
    }

    Singleton.instance.selectedService=services.first;
    Singleton.instance.selectedIndex=services.first.id;


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
      body:
      FutureBuilder(
        future: getServices(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return Text("error in koadinb data");
          }
          if(snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // DropdownButton(
                //   // Initial Value
                //   value: dropdownvalue,
                //
                //   // Down Arrow Icon
                //   icon: const Icon(Icons.keyboard_arrow_down),
                //
                //   // Array list of items
                //   items: snapshot.data?.map((ServiceModel items) {
                //     return DropdownMenuItem(
                //       value: items.id,
                //       child: Text(items.serviceName,
                //         style: TextStyle(color: Colors.black),),
                //     );
                //   }).toList(),
                //   // After selecting the desired option,it will
                //   // change button value to selected value
                //   onChanged: (dynamic newValue) {
                //     setState(() {
                //       dropdownvalue = newValue;
                //     });
                //   },
                // ),
                DropdownButton<ServiceModel>(
                  value:Singleton.instance.selectedService,
                  hint: Text('Select a service'),
                  onChanged: (ServiceModel? newValue) {
                    setState(() {
                      Singleton.instance.selectedIndex  = newValue?.id;
                      Singleton.instance.selectedService=newValue;
                      print(Singleton.instance.selectedIndex);
                      print(Singleton.instance.selectedService?.serviceName);
                    });
                  },
                  items: services.map<DropdownMenuItem<ServiceModel>>((ServiceModel service) {
                    return DropdownMenuItem<ServiceModel>(
                      value: service,
                      child: Text(service.serviceName),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 30,
                ),
                selectedImage != null
                    ? SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.network(selectedImage!.path))
                    : InkWell(
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();

                    final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);

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
                SizedBox(
                  height: 200,
                  width: 200,
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
                      ElevatedButton(
                        onPressed: () async {
                          String serviceId = createIdFromDateTime();
                          String category = selectedServiceId!;
                          String serviceName = _serviceController.text;
                          String serviceImage = await uploadFile();
                          saveData( {
                            'product_id': serviceId,
                            'product_image': serviceImage,
                            'product_name': serviceName
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[900],
                        ),
                        child: Text('Save Service'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
            return Center(child: CircularProgressIndicator());

        }
      ),
    );
  }

  Future<void> saveData(Map<String,dynamic> productData) async {
    try {
      CollectionReference serviceRef =
      FirebaseFirestore.instance.collection('services');
      DocumentReference serviceDocRef = serviceRef.doc(Singleton.instance.selectedService!.id);
      DocumentSnapshot documentSnapshot = await serviceDocRef.get();
      if (documentSnapshot.exists) {
       // documentSnapshot.get(field)
        FieldPath fieldPath = FieldPath(const ['product']);
        List<dynamic> existingProducts = documentSnapshot.get(fieldPath) as List<dynamic>?? [];
        List<dynamic> updatedProducts = [...existingProducts, productData];

        await serviceDocRef.set({'id':Singleton.instance.selectedService!.id,'name':Singleton.instance.selectedService!.serviceName,'product': updatedProducts});
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
