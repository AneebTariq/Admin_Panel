// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:admin_panel/ui/desktopscafold/feedback.dart';
import 'package:admin_panel/ui/desktopscafold/history.dart';
import 'package:admin_panel/ui/desktopscafold/messagescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chat_screen.dart';
import 'services.dart';

class Deskhome extends StatefulWidget {
  const Deskhome({super.key});

  @override
  State<Deskhome> createState() => _DeskhomeState();
}

class _DeskhomeState extends State<Deskhome> {
  final Query<Map<String, dynamic>> usersCollection = FirebaseFirestore.instance
      .collection('ServiceRequest')
      .where('status', isEqualTo: 'pending');

  final Query<Map<String, dynamic>> aprovedrequest = FirebaseFirestore.instance
      .collection('ServiceRequest')
      .where('status', isEqualTo: 'aproved');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Center(child: Text('I N S T A N T     S E R V I C E S')),
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
                    //
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
                  onTap: () {
                    Get.to(() => const Myservices());
                  },
                ),
              ],
            ),
          ),

          //body
          Expanded(
            flex: 3,
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'W E L C O M E ',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 25,
                      color: Colors.black),
                ),
                // 4 box
                const SizedBox(
                  height: 40,
                ),
                // services requests
                const ListTile(
                  title: Text(
                    'Services Requests',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: usersCollection.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return AspectRatio(
                      aspectRatio: 5,
                      child: SizedBox(
                        width: double.infinity,
                        child: GridView.builder(
                            itemCount: snapshot.data!.docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Card(
                                  // color: Colors.white,
                                  child: SizedBox(
                                    height: 100,
                                    child: ListView(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 10),
                                          child: Text(
                                            snapshot.data!.docs[index]
                                                ['user_name'],
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            'service: ' +
                                                snapshot.data!.docs[index]
                                                    ['service_name'],
                                          ),
                                          subtitle: Text(snapshot.data!
                                                  .docs[index]['service_date'] +
                                              "  " +
                                              snapshot.data!.docs[index]
                                                  ['service_time']),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Text(
                                            'Detail: ' +
                                                snapshot.data!.docs[index]
                                                    ['service_detail'],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  String requeststatus =
                                                      'aproved';
                                                  String mydate =
                                                      snapshot.data!.docs[index]
                                                          ['service_date'];
                                                  String mytime =
                                                      snapshot.data!.docs[index]
                                                          ['service_time'];
                                                  String myemail =
                                                      snapshot.data!.docs[index]
                                                          ['user_email'];
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          'ServiceRequest')
                                                      .where('service_date',
                                                          isEqualTo: mydate)
                                                      .where('service_time',
                                                          isEqualTo: mytime)
                                                      .where('user_email',
                                                          isEqualTo: myemail)
                                                      .get()
                                                      .then((querySnapshot) {
                                                    querySnapshot.docs
                                                        // ignore: avoid_function_literals_in_foreach_calls
                                                        .forEach(
                                                            (documentSnapshot) {
                                                      documentSnapshot.reference
                                                          .update({
                                                        'status': requeststatus
                                                      });
                                                    });
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.greenAccent,
                                                ),
                                                child: const Text('Accept'),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  String requeststatus =
                                                      'rejected';
                                                  String mydate =
                                                      snapshot.data!.docs[index]
                                                          ['service_date'];
                                                  String mytime =
                                                      snapshot.data!.docs[index]
                                                          ['service_time'];
                                                  String myemail =
                                                      snapshot.data!.docs[index]
                                                          ['user_email'];
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          'ServiceRequest')
                                                      .where('service_date',
                                                          isEqualTo: mydate)
                                                      .where('service_time',
                                                          isEqualTo: mytime)
                                                      .where('user_email',
                                                          isEqualTo: myemail)
                                                      .get()
                                                      .then((querySnapshot) {
                                                    querySnapshot.docs
                                                        // ignore: avoid_function_literals_in_foreach_calls
                                                        .forEach(
                                                            (documentSnapshot) {
                                                      documentSnapshot.reference
                                                          .update({
                                                        'status': requeststatus
                                                      });
                                                    });
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                ),
                                                child: const Text('Reject'),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    );
                  },
                ),

                const SizedBox(
                  height: 20,
                ),
                // Aproved Requests
                const ListTile(
                  title: Text(
                    'Aproved Service Requests',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                // Aproved list
                StreamBuilder<QuerySnapshot>(
                  stream: aprovedrequest.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
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
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                  child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(snapshot.data!.docs[index]
                                        ['user_name']),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Service Name: ' +
                                            snapshot.data!.docs[index]
                                                ['service_name']),
                                        Text('Date & Time: ' +
                                            snapshot.data!.docs[index]
                                                ['service_date'] +
                                            "  " +
                                            snapshot.data!.docs[index]
                                                ['service_time']),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Get.to(() => OrderChatPage(
                                                  requestId: snapshot
                                                      .data!.docs[index]['uId'],
                                                  theirName:
                                                      snapshot.data!.docs[index]
                                                          ['user_name']));
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.greenAccent,
                                            ),
                                            child: const Text('Chat')),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              String requeststatus =
                                                  'completed';
                                              String mydate = snapshot.data!
                                                  .docs[index]['service_date'];
                                              String mytime = snapshot.data!
                                                  .docs[index]['service_time'];
                                              String myemail = snapshot.data!
                                                  .docs[index]['user_email'];
                                              FirebaseFirestore.instance
                                                  .collection('ServiceRequest')
                                                  .where('service_date',
                                                      isEqualTo: mydate)
                                                  .where('service_time',
                                                      isEqualTo: mytime)
                                                  .where('user_email',
                                                      isEqualTo: myemail)
                                                  .get()
                                                  .then((querySnapshot) {
                                                querySnapshot.docs
                                                    // ignore: avoid_function_literals_in_foreach_calls
                                                    .forEach(
                                                        (documentSnapshot) {
                                                  documentSnapshot.reference
                                                      .update({
                                                    'status': requeststatus
                                                  });
                                                });
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.greenAccent,
                                            ),
                                            child: const Text('Completed')),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                            );
                          }),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
