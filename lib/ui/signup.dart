import 'package:admin_panel/repository/homecontroller.dart';
import 'package:admin_panel/ui/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/usermodel.dart';
import '../repository/sharedprefrence.dart';
import 'desktopscafold/deskhome.dart';

class AdminSignup extends StatefulWidget {
  const AdminSignup({super.key});

  @override
  State<AdminSignup> createState() => _AdminSignupState();
}

class _AdminSignupState extends State<AdminSignup> {
  HomeController homecontroller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('S I G N    U P'),
        backgroundColor: Colors.grey[900],
        centerTitle: true,
      ),
      body: Form(
        key: homecontroller.registerFormKey,
        child: Row(
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
                          controller: homecontroller.emailController,
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
                          controller: homecontroller.passwordController,
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
                            onPressed: () async {
                              homecontroller.checkregister();
                              try {
                                final credential = await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                  email: homecontroller.emailController.text,
                                  password:
                                      homecontroller.passwordController.text,
                                );
                                await SharedPrefClient().setUser(UserModel(
                                    credential.user!.uid,
                                    credential.user!.email!));
                                Get.offAll(() => const Deskhome());
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  if (kDebugMode) {
                                    print('The password provided is too weak.');
                                  }
                                  Get.snackbar('Weak Password',
                                      ' Enter Strong Password ',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM);
                                } else if (e.code == 'email-already-in-use') {
                                  if (kDebugMode) {
                                    print(
                                        'The account already exists for that email.');
                                  }
                                  Get.snackbar(
                                      'Wrong Email', ' Enter another Email ',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM);
                                }
                              } catch (e) {
                                if (kDebugMode) {
                                  print(e);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[900],
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(fontSize: 28),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already Have Account ."),
                          TextButton(
                              onPressed: () {
                                Get.offAll(() => const AdminLogin());
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(color: Colors.blue),
                              ))
                        ],
                      ),
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
                'assets/images/1.jpg',
                width: 900,
                height: 700,
              ),
            )
          ],
        ),
      ),
    );
  }
}
