// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ServicesHistory extends StatefulWidget {
  const ServicesHistory({super.key});

  @override
  State<ServicesHistory> createState() => _ServicesHistoryState();
}

class _ServicesHistoryState extends State<ServicesHistory> {
  final Query<Map<String, dynamic>> userrequests =
      FirebaseFirestore.instance.collection('ServiceRequest');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: const Text('Service History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: userrequests.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                        child: ListTile(
                      leading: Text(snapshot.data!.docs[index]['user_name']),
                      title: Text('Service Name: ' +
                          snapshot.data!.docs[index]['service_name']),
                      subtitle: Text('Date & Time: ' +
                          snapshot.data!.docs[index]['service_date'] +
                          "  " +
                          snapshot.data!.docs[index]['service_time']),
                    )),
                  );
                }),
          );
        },
      ),
    );
  }
}
