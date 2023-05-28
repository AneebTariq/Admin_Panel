import 'package:flutter/material.dart';

class ServicesHistory extends StatefulWidget {
  const ServicesHistory({super.key});

  @override
  State<ServicesHistory> createState() => _ServicesHistoryState();
}

class _ServicesHistoryState extends State<ServicesHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: const Text('Service History'),
      ),
    );
  }
}
