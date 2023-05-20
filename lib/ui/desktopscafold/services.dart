import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'addservice.dart';
import 'deskhome.dart';

class Myservices extends StatefulWidget {
  const Myservices({super.key});

  @override
  State<Myservices> createState() => _MyservicesState();
}

class _MyservicesState extends State<Myservices> {
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
                  title: const Text('N O T I F I C A T I O N S'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('H I S T O R Y'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.room_service),
                  title: const Text('S E R V I C E S'),
                  onTap: () {
                    //
                  },
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
                  ),
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
