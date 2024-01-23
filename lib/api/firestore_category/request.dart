import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/api/firestore_category/dto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class FirestoreCategoryApi {
  final Uuid uuid = const Uuid();
  CollectionReference categoriesCollection =
      FirebaseFirestore.instance.collection('categories');

  Future<List<CategoryModel>> getCategoriesList() async {
    try {
      QuerySnapshot categoriesSnapshot = await categoriesCollection.orderBy('filterOrders', descending: false).get();
      List<CategoryModel> categoriesList = [];

      for (QueryDocumentSnapshot categoriesDoc in categoriesSnapshot.docs) {
        if (categoriesDoc.exists) {
          final categoriesData = CategoryModel.fromJson(
              categoriesDoc.data() as Map<String, dynamic>);
          categoriesList.add(categoriesData);
        }
      }
      print('categories list: $categoriesList');
      return categoriesList;
    } catch (e) {
      print('Error getting categories list: $e');
      return [];
    }
  }

  Future<void> addCategory(String category, String image, String uuid) async {
    try {
      CategoryModel categories = CategoryModel(
        uuid: uuid,
        category: category,
        image: image,
      );
      DocumentReference categoryDoc = categoriesCollection.doc(uuid);
      await categoryDoc.set(categories.toJson());
      print('User ID: $uuid');
    } catch (e) {
      print('Error signing in anonymously: $e');
    }
  }

  Future<void> editCategory(String uuid, String newCategory, int? filterOrder ) async {
    try {
      DocumentReference productDoc = categoriesCollection.doc(uuid);
      await productDoc.update({
        'category': newCategory,
        'filterOrders': filterOrder
      });
      print('User ID: $uuid');
    } catch (e) {
      print('Error signing in anonymously: $e');
    }
  }


  Future<void> deleteCategory(String uuid) async {
    try {
      DocumentReference categoryDoc = categoriesCollection.doc(uuid);
      await categoryDoc.delete();
    } catch (e) {
      print('Error deleting user account: $e');
    }
  }

  Future<void> editImage(String uuid, String newImage) async {
    try {
      DocumentReference productDoc = categoriesCollection.doc(uuid);
      await productDoc.update({
        'image': newImage,
      });
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
      if (image != null) {
        List<int> imageBytes = image.toList();
        String base64Image = base64Encode(imageBytes);
      }
      return image;
    } catch (e) {
      print("Помилка при отриманні даних з Firebase: $e");
      return null;
    }
  }

  Future<String> saveImage(Uint8List? file, String uuid) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final path = 'image/categories/$uuid';
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
      final path = 'image/categories/$uuid';
      final mountainsRef = storageRef.child(path);
      await mountainsRef.delete();
      return path;
    } catch (e) {
      print('фотографію не зберегло: $e');
      return '';
    }
  }

  Future<void> updateShow(String uuid, bool isShow) async {
    try {
      DocumentReference categoryDoc = categoriesCollection.doc(uuid);
      await categoryDoc.update({
        'isShow': isShow,
      });
      print('User ID: $uuid');
    } catch (e) {
      print('Error signing in anonymously: $e');
    }
  }
}
