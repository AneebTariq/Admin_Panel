

import 'addservice.dart';

class Singleton {
  static Singleton _instance = Singleton._();
  Singleton._();
  static Singleton get instance => _instance;



  ServiceModel? selectedService ;
  String? selectedIndex;


}

