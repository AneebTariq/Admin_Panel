import 'dart:io';
import 'package:admin_panel/models/service_list_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/service_controller.dart';
import 'addservice.dart';
import 'deskhome.dart';
import 'edit_service.dart';
import 'feedback.dart';
import 'history.dart';
import 'messagescreen.dart';

class Myservices extends StatefulWidget {
  const Myservices({super.key});

  @override
  State<Myservices> createState() => _MyservicesState();
}

class _MyservicesState extends State<Myservices> {

  ServiceController controller=ServiceController();
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
      body: FutureBuilder<List<ServiceListModel>>(
        future: controller.fetchServices(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return const Center(child: Text("Error in getting services"),);
          }else if(snapshot.hasData) {
            return Row(
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
                      Container(
                          alignment: Alignment.topRight,
                          padding: const EdgeInsets.only(right: 20.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(() => const Addservice());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[900],
                            ),
                            child: const Text(
                              'Add Service',
                              style: TextStyle(fontSize: 16),
                            ),
                          )),
                      // 4 box
                      const SizedBox(
                        height: 40,
                      ),

                      const SizedBox(
                        height: 40,
                      ),

                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {

                            return  SizedBox(
                              height: 400,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left:30.0),
                                    child: Text(snapshot.data![index].name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18
                                    ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  ListView.builder(
                                    shrinkWrap: true,
                                      itemCount: snapshot.data![index].product.length,
                                      itemBuilder: (context,item){
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30.0),
                                        child: Card(
                                          child: ListTile(
                                            leading: const Icon(Icons.image),
                                            title:  Text(snapshot.data![index].product[item].productName),
                                            trailing: SizedBox(
                                              width: 100,
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        Get.to(()=>EditService(
                                                          service:snapshot.data![index],
                                                          product:snapshot.data![index].product[item]
                                                        ));

                                                      },
                                                      icon: const Icon(Icons.edit)),
                                                  IconButton(
                                                      onPressed: () async {
                                                       bool check= await controller.deleteService(snapshot.data![index].id,snapshot.data![index].name,snapshot.data![index].product[item].productId);
                                                       if(check){
                                                         Get.offAll(()=>Myservices());
                                                       }
                                                      },
                                                      icon: const Icon(Icons.delete)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                ],
                              ),
                            );

                            }),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }else{
            return const Center(child: CircularProgressIndicator(),);
          }
        }
      ),
    );
  }
}
