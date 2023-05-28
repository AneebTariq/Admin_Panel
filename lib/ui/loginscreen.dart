import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'desktopscafold/deskhome.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('L O G I N'),
        backgroundColor: Colors.grey[900],
        centerTitle: true,
      ),
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 15,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Enter Email',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Enter Password',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.offAll(() => const Deskhome());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[900],
                            maximumSize: const Size(360, 80),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          //scond coumn
          SizedBox(
            height: 700,
            width: 900,
            child: Image.asset(
              'assets/images/2.jpg',
              width: 900,
              height: 700,
            ),
          )
        ],
      ),
    );
  }
}
