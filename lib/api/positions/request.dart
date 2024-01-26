import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/api/firestore_product/dto.dart';
import 'package:delivery/api/positions/dto.dart';
import 'package:uuid/uuid.dart';

class PositionApi {
  CollectionReference positionCollection =
      FirebaseFirestore.instance.collection('positions');

  Future<List<PositionGroupModel>> getPositionsList() async {
    try {
      QuerySnapshot positionSnapshot = await positionCollection.get();
      List<PositionGroupModel> positionsList = [];

      for (QueryDocumentSnapshot positionsDoc in positionSnapshot.docs) {
        if (positionsDoc.exists) {
          final tegData = PositionGroupModel.fromJson(
              positionsDoc.data() as Map<String, dynamic>);
          positionsList.add(tegData);
        }
      }
      print('position list: $positionsList');
      return positionsList;
    } catch (e) {
      print('Error getting position list: $e');
      return [];
    }
  }

  Future<void> addPosition(PositionGroupModel positionGroupModel) async {
    try {
      DocumentReference positionDoc = positionCollection.doc(positionGroupModel.uuid);
      await positionDoc.set(jsonDecode(jsonEncode(positionGroupModel.toJson())));
      print('User ID: ');
    } catch (e) {
      print('Error signing in anonymously: $e');
    }
  }

  Future<void> editPosition(PositionGroupModel positionGroupModel) async {
    try {
      DocumentReference positionDoc =
          positionCollection.doc(positionGroupModel.uuid);
      await positionDoc
          .update(jsonDecode(jsonEncode(positionGroupModel.toJson())));
      print('User');
    } catch (e) {
      print('Error signing in anonymously: $e');
    }
  }

  Future<void> deletePosition(String uuid) async {
    try {
      DocumentReference positionDoc = positionCollection.doc(uuid);
      await positionDoc.delete();
    } catch (e) {
      print('Error deleting user account: $e');
    }
  }
}
