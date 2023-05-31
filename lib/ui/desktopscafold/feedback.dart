// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'deskhome.dart';
import 'history.dart';
import 'services.dart';

class ServiceFeedback extends StatefulWidget {
  const ServiceFeedback({super.key});

  @override
  State<ServiceFeedback> createState() => _ServiceFeedbackState();
}

class _ServiceFeedbackState extends State<ServiceFeedback> {
  final Query<Map<String, dynamic>> myfeedback =
      FirebaseFirestore.instance.collection('Feedback');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: const Text('FeedBacks'),
      ),
      body: Row(
        children: [
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
                    Get.to(() => const Deskhome());
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
                  onTap: () {
                    Get.to(() => const Myservices());
                  },
                ),
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: myfeedback.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20),
                        child: Card(
                            child: ListTile(
                          title: Text('User Email: ' +
                              snapshot.data!.docs[index]['Email']),
                          subtitle: Text('FeedBack: ' +
                              snapshot.data!.docs[index]['userfeedback']),
                        )),
                      );
                    }),
              );
            },
          ),
        ],
      ),
    );
  }
}
