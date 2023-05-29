import 'package:admin_panel/repository/homecontroller.dart';
import 'package:admin_panel/ui/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/usermodel.dart';
import '../repository/sharedprefrence.dart';
import 'desktopscafold/deskhome.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  HomeController homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('L O G I N'),
        backgroundColor: Colors.grey[900],
        centerTitle: true,
      ),
      body: Form(
        key: homeController.loginFormKey,
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
                          controller: homeController.emailController,
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
                          controller: homeController.passwordController,
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
                              homeController.checkLogin();
                              try {
                                // ignore: unused_local_variable
                                final credential = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: homeController.emailController.text,
                                  password:
                                      homeController.passwordController.text,
                                );
                                await SharedPrefClient().setUser(UserModel(
                                    credential.user!.uid,
                                    credential.user!.email!));
                                Get.offAll(() => const Deskhome());
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  Get.snackbar('Wrong',
                                      ' Please Enter Correct Email/Password ',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM);
                                  if (kDebugMode) {
                                    print('No user found for that email.');
                                  }
                                } else if (e.code == 'wrong-password') {
                                  if (kDebugMode) {
                                    print(
                                        'Wrong password provided for that user.');
                                  }
                                  Get.snackbar('Wrong Password',
                                      ' Enter Correct Password ',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[900],
                              maximumSize: const Size(360, 100),
                            ),
                            child: const Text(
                              'Login',
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
                          const Text("Don't Have Account ?"),
                          TextButton(
                              onPressed: () {
                                Get.offAll(() => const AdminSignup());
                              },
                              child: const Text(
                                'Sign Up',
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
                'assets/images/2.jpg',
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
