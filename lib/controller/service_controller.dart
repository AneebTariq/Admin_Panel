import 'package:cloud_firestore/cloud_firestore.dart';

import '../ui/desktopscafold/addservice.dart';
import '../ui/desktopscafold/singleton.dart';

class ServiceController{
  getServiceList() {

  }

  updateService(ServiceModel model,Map<String,dynamic> productData,String oldProductId) async {
    try {
      CollectionReference serviceRef =
      FirebaseFirestore.instance.collection('services');
      DocumentReference serviceDocRef = serviceRef.doc(model.id);
      DocumentSnapshot documentSnapshot = await serviceDocRef.get();
      if (documentSnapshot.exists) {
        // documentSnapshot.get(field)
        FieldPath fieldPath = FieldPath(const ['product']);
        List<dynamic> existingProducts = documentSnapshot.get(fieldPath) as List<dynamic>?? [];

        // Find the index of the product within the array based on its product ID
        int productIndex = existingProducts.indexWhere((product) => product['product_id'] == oldProductId);

        if (productIndex != -1) {
          // Update the specific product in the array
          existingProducts[productIndex] = productData;

          final updatedProductList = existingProducts;

          //List<dynamic> updatedProducts = [...existingProducts, productData];

          await serviceDocRef.update({
            'id': model.id,
            'name': model.serviceName,
            'product': updatedProductList
          });
        }
      }

    } catch (e) {
      print('Error: $e');
    }
  }

  addService(ServiceModel model,Map<String,dynamic> productData) async {
    try {
      CollectionReference serviceRef =
      FirebaseFirestore.instance.collection('services');
      DocumentReference serviceDocRef = serviceRef.doc(model.id);
      DocumentSnapshot documentSnapshot = await serviceDocRef.get();
      if (documentSnapshot.exists) {
        // documentSnapshot.get(field)
        FieldPath fieldPath = FieldPath(const ['product']);
        List<dynamic> existingProducts = documentSnapshot.get(fieldPath) as List<dynamic>?? [];
        List<dynamic> updatedProducts = [...existingProducts, productData];

        await serviceDocRef.set({'id':model.id,'name':model.serviceName,'product': updatedProducts});
      }

    } catch (e) {
      print('Error: $e');
    }
  }
}