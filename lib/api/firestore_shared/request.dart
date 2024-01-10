import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import 'dto.dart';

class SharedApi {
  final uuid = Uuid();
  CollectionReference sharesCollection =
      FirebaseFirestore.instance.collection('promo');

  Future<List<SharesModel>> getSharesList() async {
    try {
      QuerySnapshot tagsSnapshot = await sharesCollection.get();
      List<SharesModel> sharesList = [];

      for (QueryDocumentSnapshot sharesDoc in tagsSnapshot.docs) {
        if (sharesDoc.exists) {
          final sharesData =
              SharesModel.fromJson(sharesDoc.data() as Map<String, dynamic>);
          sharesList.add(sharesData);
        }
      }
      return sharesList;
    } catch (e) {
      print('Error getting shared list: $e');
      return [];
    }
  }


  Future<void> addShares(SharesModel sharesModel) async {
    try {
      SharesModel shares = SharesModel(
          uid: sharesModel.uid,
          title: sharesModel.title,
          description: sharesModel.description,
          image: sharesModel.image);

      DocumentReference sharesDoc = sharesCollection.doc(sharesModel.uid);
      await sharesDoc.set(shares.toJson());
    } catch (e) {
      print('Error signing in anonymously: $e');
    }
  }

  Future<void> editShares(String uuid, SharesModel newShares) async {
    try {
      DocumentReference productDoc = sharesCollection.doc(uuid);
      await productDoc.update(
        newShares.toJson(),
      );
      print('User ID: $uuid');
    } catch (e) {
      print('Error signing in anonymously: $e');
    }
  }


  Future<Uint8List?> getImage(String name) async {
    final Reference storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child(name);
    try {
      final image = await imageRef.getData();
      return image;
    } catch (e) {
      print("Помилка при отриманні даних з Firebase: $e");
      return null;
    }
  }

  Future<String> saveImage(Uint8List? file, String uuid) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final path = 'image/shares/$uuid';
      final mountainsRef = storageRef.child(path);
      await mountainsRef.putData(file!);
      return path;
    } catch (e) {
      print('фотографію не зберегло: $e');
      return '';
    }
  }

  Future<String> deleteImage(String uuid) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final path = 'image/shares/$uuid';
      final mountainsRef = storageRef.child(path);
      await mountainsRef.delete();
      return path;
    } catch (e) {
      print('фотографію не зберегло: $e');
      return '';
    }
  }

  Future<void> deleteShared(String uuid) async {
    try {
      DocumentReference sharesDoc = sharesCollection.doc(uuid);
      await sharesDoc.delete();
    } catch (e) {
      print('Error deleting user account: $e');
    }
  }
}
