import 'package:admin_panel/ui/desktopscafold/feedback.dart';
import 'package:admin_panel/ui/desktopscafold/history.dart';
import 'package:admin_panel/ui/desktopscafold/messagescreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'services.dart';

class Deskhome extends StatefulWidget {
  const Deskhome({super.key});

  @override
  State<Deskhome> createState() => _DeskhomeState();
}

class _DeskhomeState extends State<Deskhome> {
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
                AspectRatio(
                  aspectRatio: 5,
                  child: SizedBox(
                    width: double.infinity,
                    child: GridView.builder(
                        itemCount: 5,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Container(
                              color: Colors.white,
                              child: const Center(
                                child: Text('Requests For Services'),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Completed Requests
                const ListTile(
                  title: Text(
                    'Services Requests Completed',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, indes) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 80,
                            color: Colors.white,
                            child: const Center(
                              child: Text('Completed Request'),
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
