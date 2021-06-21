import 'package:skin_detection/models/api_response.dart';
import 'package:skin_detection/models/product.dart';
import 'package:skin_detection/models/user_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get_it/get_it.dart';

import 'authentication_service.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference _productsCollectionReference =
      FirebaseFirestore.instance.collection("products");

  AuthenticationService get authenticationService =>
      GetIt.I<AuthenticationService>();

  Future createUser(UserDetails user) async {
    try {
      await _usersCollectionReference.doc(user.uid).set({
        'firstName': user.firstName,
        'lastName': user.lastName,
        'phoneNumber': user.phoneNumber,
        'address': user.address
      });
      return APIResponse<bool>(error: false);
    } catch (e) {
      return APIResponse<bool>(error: true, errorMessage: e.message);
    }
  }

  Future updateUserDetails(Map<String, String> details) async {
    UserDetails user = await authenticationService.currentUser();
    try {
      await _usersCollectionReference.doc(user.uid).set({
        'skin_tone': details['skin_tone'],
        'skin_type': details['skin_type'],
      }, SetOptions(merge: true));
      UserDetails userDetails;
      _usersCollectionReference.doc(user.uid).get().then((doc) => {
            if (doc.exists)
              {userDetails = UserDetails.fromJson(doc.data())}
            else
              {print("Document does not exists")}
          });
      return APIResponse<UserDetails>(data: userDetails, error: false);
    } catch (e) {
      return APIResponse<bool>(error: true, errorMessage: e.message);
    }
  }

  Future getAllProducts() async {
    QuerySnapshot querySnapShot = await _productsCollectionReference.get();

    return querySnapShot.docs.map(
      (e) {
        Product product = Product.fromJson(e.data());
        product.id = e.id;
        return product;
      },
    ).toList();
  }
}
