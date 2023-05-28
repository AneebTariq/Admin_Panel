import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'addservice.dart';
import 'deskhome.dart';
import 'feedback.dart';
import 'history.dart';
import 'messagescreen.dart';

class Myservices extends StatefulWidget {
  const Myservices({super.key});

  @override
  State<Myservices> createState() => _MyservicesState();
}

class _MyservicesState extends State<Myservices> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  XFile? selectedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Center(
          child: Text('S E R V I C E S'),
        ),
      ),
      body: Row(
        children: [
          //drawer
          Drawer(
            backgroundColor: Colors.grey[300],
            child: Column(
              children: [
                const DrawerHeader(
                    child: Icon(
                  Icons.category_outlined,
                  size: 50,
                )),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('D A S H B O A R D'),
                  onTap: () {
                    Get.offAll(() => const Deskhome());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.message_outlined),
                  title: const Text('M E S S A G E S'),
                  onTap: () {
                    Get.to(() => const Messagescreen());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('H I S T O R Y'),
                  onTap: () {
                    Get.to(() => const ServicesHistory());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.feedback_outlined),
                  title: const Text('F E E D B A C K S'),
                  onTap: () {
                    Get.to(() => const ServiceFeedback());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.room_service),
                  title: const Text('S E R V I C E S'),
                  onTap: () {},
                ),
              ],
            ),
          ),
          // services list
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                // add service button
                Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => const Addservice());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                      ),
                      child: const Text(
                        'Add Service',
                        style: TextStyle(fontSize: 20),
                      ),
                    )),
                // 4 box
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
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
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[900],
                            ),
                            child: const Text('Save Service'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, indes) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Card(
                            child: ListTile(
                              leading: const Icon(Icons.image),
                              title: const Text('Service Name'),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.edit)),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.delete)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
