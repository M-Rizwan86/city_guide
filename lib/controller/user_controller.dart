import 'package:cloud_firestore/cloud_firestore.dart';

class UserController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot<Object?>>> getUserData(String uId) async {
    final QuerySnapshot userData =
        await _firestore.collection('Users').where('id', isEqualTo: uId).get();
    return userData.docs;
  }
}
