import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_list_model.dart';
import '../ui/desktopscafold/addservice.dart';
import '../ui/desktopscafold/singleton.dart';

class ServiceController{
  Future<List<ServiceListModel>> fetchServices() async {
    // Replace 'yourCollectionPath' with the actual path to your collection in Firestore
    CollectionReference collectionRef =
    FirebaseFirestore.instance.collection('services');
    List<ServiceListModel> serviceList = [];
    try {
      QuerySnapshot querySnapshot = await collectionRef.get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        // Access the document data
        Map<String, dynamic> documentData =
        documentSnapshot.data() as Map<String, dynamic>;

        // Create a Document instance
        ServiceListModel service = ServiceListModel.fromMap(documentData);

        // Add the document to the list
        serviceList.add(service);
      }
    } catch (e) {
      // Handle any errors that occur
      print('Error: $e');
    }

    return serviceList;
  }

  Future<bool> updateService(String serviceID,String serviceName,Map<String,dynamic> productData,String oldProductId) async {
    try {
      CollectionReference serviceRef =
      FirebaseFirestore.instance.collection('services');
      DocumentReference serviceDocRef = serviceRef.doc(serviceID);
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
            'id': serviceID,
            'name': serviceName,
            'product': updatedProductList
          });
        }
      }
      return true;

    } catch (e) {
     // return false;
      print('Error: $e');
    }

    return true;
  }
  Future<bool> deleteService(String serviceID,String serviceName,String oldProductId) async {
    try {
      CollectionReference serviceRef =
      FirebaseFirestore.instance.collection('services');
      DocumentReference serviceDocRef = serviceRef.doc(serviceID);
      DocumentSnapshot documentSnapshot = await serviceDocRef.get();
      if (documentSnapshot.exists) {
        // documentSnapshot.get(field)
        FieldPath fieldPath = FieldPath(const ['product']);
        List<dynamic> existingProducts = documentSnapshot.get(fieldPath) as List<dynamic>?? [];

        // Find the index of the product within the array based on its product ID
        int productIndex = existingProducts.indexWhere((product) => product['product_id'] == oldProductId);

        if (productIndex != -1) {
          // Update the specific product in the array
          existingProducts.removeAt(productIndex);

          final updatedProductList = existingProducts;

          //List<dynamic> updatedProducts = [...existingProducts, productData];

          await serviceDocRef.update({
            'id': serviceID,
            'name': serviceName,
            'product': updatedProductList
          });
        }
      }
      return true;

    } catch (e) {
     // return false;
      print('Error: $e');
    }

    return true;
  }

 Future<bool> addService(ServiceModel model,Map<String,dynamic> productData) async {
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
    return true;
  }


}