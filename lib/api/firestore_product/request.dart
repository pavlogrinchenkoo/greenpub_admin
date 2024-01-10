import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/api/firestore_orders/dto.dart';
import 'package:delivery/api/firestore_product/dto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class FirestoreProductApi {
  CollectionReference productCollection =
      FirebaseFirestore.instance.collection('products');

  QuerySnapshot? snapshot = null;

  Future<List<ProductModel>> getProductsList(int limit, bool isLoadMore) async {
    if (isLoadMore) {
      snapshot = null;
    }
    try {
      if (snapshot?.docs.isNotEmpty == true) {
        var lastVisible = snapshot!.docs[snapshot!.docs.length - 1];
        QuerySnapshot productSnapshot = await productCollection
            .orderBy('uuid')
            .startAfterDocument(lastVisible)
            .limit(limit)
            .get();
        List<ProductModel> productList = [];

        for (QueryDocumentSnapshot productDoc in productSnapshot.docs) {
          if (productDoc.exists) {
            final productData = ProductModel.fromJson(
                productDoc.data() as Map<String, dynamic>);
            productList.add(productData);
          }
        }
        print('product list: $productList');
        return productList;
      } else {
        QuerySnapshot productSnapshot =
            await productCollection.orderBy('uuid').limit(limit).get();
        snapshot = productSnapshot;
        List<ProductModel> productList = [];

        for (QueryDocumentSnapshot productDoc in productSnapshot.docs) {
          if (productDoc.exists) {
            final productData = ProductModel.fromJson(
                productDoc.data() as Map<String, dynamic>);
            productList.add(productData);
          }
        }
        print('product list: $productList');
        return productList;
      }
    } catch (e) {
      print('Error getting product list: $e');
      return [];
    }
  }

  Future<List<ProductModel>> getProducts() async {
    try {
      QuerySnapshot productsSnapshot = await productCollection.get();
      List<ProductModel> productsList = [];

      for (QueryDocumentSnapshot productsDoc in productsSnapshot.docs) {
        if (productsDoc.exists) {
          final productsData =
              ProductModel.fromJson(productsDoc.data() as Map<String, dynamic>);
          productsList.add(productsData);
        }
      }
      print('products list: $productsList');
      return productsList;
    } catch (e) {
      print('Error getting products list: $e');
      return [];
    }
  }

  Future<ProductModel?> getProductData(String uid) async {
    try {
      DocumentSnapshot productDoc = await productCollection.doc(uid).get();
      if (productDoc.exists) {
        final productData =
            ProductModel.fromJson(productDoc.data() as Map<String, dynamic>);
        print(productData);
        return productData;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting product data: $e');
      return null;
    }
  }

  Future<ImageModel?> getImage(String name) async {
    final Reference storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child(name);
    try {
      final image = await imageRef.getData();
      if (image != null) {
        List<int> imageBytes = image.toList();
        String base64Image = base64Encode(imageBytes);
      }
      final imageModel = ImageModel(
        bytes: image,
        path: name,
      );
      return imageModel;
    } catch (e) {
      print("Помилка при отриманні даних з Firebase: $e");
      return null;
    }
  }

  Future<String> saveImage(Uint8List? file, String uuid) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final path = 'image/products/$uuid';
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
      final path = 'image/products/$uuid';
      final mountainsRef = storageRef.child(path);
      await mountainsRef.delete();
      return path;
    } catch (e) {
      print('фотографію не зберегло: $e');
      return '';
    }
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      String uuid = product.uuid ?? '';
      DocumentReference productDoc = productCollection.doc(uuid);
      await productDoc.set(jsonDecode(jsonEncode(product.toJson())));
      print('User ID: $uuid');
    } catch (e) {
      print('Error signing in anonymously: $e');
    }
  }

  Future<void> editProduct(ProductModel product) async {
    try {
      String uuid = product.uuid ?? '';
      DocumentReference productDoc = productCollection.doc(uuid);
      final jsProduct = jsonDecode(jsonEncode(product.toJson()));
      await productDoc.update(jsProduct);
      print('User ID: $uuid');
    } catch (e) {
      print('Error signing in anonymously: $e');
    }
  }

  Future<void> deleteProduct(String uuid) async {
    try {
      DocumentReference userDoc = productCollection.doc(uuid);
      await userDoc.delete();
    } catch (e) {
      print('Error deleting user account: $e');
    }
  }
}
