import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/api/system/dto.dart';

class SystemApi {
  CollectionReference systemCollection =
      FirebaseFirestore.instance.collection('System');

  Future<SystemModel?> getSystem() async {
    try {
      DocumentSnapshot systemDoc = await systemCollection.doc('System').get();
      if (systemDoc.exists) {
        final systemData =
            SystemModel.fromJson(systemDoc.data() as Map<String, dynamic>);
        print(systemData);
        return systemData;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting product data: $e');
      return null;
    }
  }

  Future<void> saveSystem(SystemModel systemModel) async {
    try {
      DocumentReference systemDoc = systemCollection.doc('System');
      await systemDoc.set(systemModel.toJson());
      print('User ID: $systemModel');
    } catch (e) {
      print('Error signing in anonymously: $e');
    }
  }
}
