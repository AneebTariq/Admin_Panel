// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
      body: StreamBuilder<QuerySnapshot>(
        stream: myfeedback.snapshots(),
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
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                        child: ListTile(
                      title: Text(
                          'User Email: ' + snapshot.data!.docs[index]['Email']),
                      subtitle: Text('FeedBack: ' +
                          snapshot.data!.docs[index]['userfeedback']),
                    )),
                  );
                }),
          );
        },
      ),
    );
  }
}
