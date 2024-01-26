import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/api/firestore_user/dto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class FirestoreUserApi {
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  QuerySnapshot? snapshot = null;

  Future<List<UserModel>> getUsersList(int limit) async {
    try {
      if (snapshot?.docs.isNotEmpty == true) {
        var lastVisible =
        snapshot!.docs[snapshot!.docs.length - 1];
      QuerySnapshot usersSnapshot = await userCollection.orderBy('phone').startAfterDocument(lastVisible).limit(limit).get();
      List<UserModel> userList = [];
      for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
        if (userDoc.exists) {
          final userData =
              UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
          userList.add(userData);
        }
      }
      print('Users list: $userList');
      return userList;
    } else {
        QuerySnapshot usersSnapshot = await userCollection.orderBy('phone').limit(limit).get();
        List<UserModel> userList = [];
        for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
          if (userDoc.exists) {
            final userData =
            UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
            userList.add(userData);
          }
        }
        print('Users list: $userList');
        return userList;
    }
    } catch (e) {
      print('Error getting users list: $e');
      return [];
    }
  }

  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot userDoc = await userCollection.doc(uid).get();
      if (userDoc.exists) {
        final userData =
            UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
        print(userData);
        return userData;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting user data: $e');
      return null;
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

  Future<void> editUser(UserModel user) async {
    try {
      String uid = user.uid ?? '';
      DocumentReference userDoc = userCollection.doc(uid);
      await userDoc.update(user.toJson());
      print('User ID: $uid');
    } catch (e) {
      print('Error signing in anonymously: $e');
    }
  }

  Future<void> editPoints(String uid, int points) async {
    try {
      DocumentReference userDoc = userCollection.doc(uid);
      await userDoc.update({
        'points': points
      });
    } catch (e) {
      print('Error deleting user account: $e');
    }
  }

  Future<void> deleteAccount(String uid) async {
    try {
      CollectionReference userCollection =
          FirebaseFirestore.instance.collection('users');
      DocumentReference userDoc = userCollection.doc(uid);
      await userDoc.delete();
    } catch (e) {
      print('Error deleting user account: $e');
    }
  }


}
