import 'package:flutter/material.dart';

class ServiceFeedback extends StatefulWidget {
  const ServiceFeedback({super.key});

  @override
  State<ServiceFeedback> createState() => _ServiceFeedbackState();
}

class _ServiceFeedbackState extends State<ServiceFeedback> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: const Text('FeedBacks'),
      ),
    );
  }
}
