import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/api/firestore_orders/dto.dart';

class FirestoreOrdersApi {
  CollectionReference orderCollection =
  FirebaseFirestore.instance.collection('orders');

  QuerySnapshot? snapshot = null;

  Future<List<OrderModel>> getOrdersList(int limit) async {
    try {
      if (snapshot?.docs.isNotEmpty == true) {
        var lastVisible =
        snapshot!.docs[snapshot!.docs.length - 1];
      QuerySnapshot ordersSnapshot = await orderCollection.orderBy('time',  descending: true).startAfterDocument(lastVisible).limit(limit).get();
      List<OrderModel> orderList = [];
      for (QueryDocumentSnapshot ordersDoc in ordersSnapshot.docs) {
        if (ordersDoc.exists) {
          final userData =
          OrderModel.fromJson(ordersDoc.data() as Map<String, dynamic>);
          orderList.add(userData);
        }
        snapshot = ordersSnapshot;
      }
      return orderList;
    } else {
        QuerySnapshot ordersSnapshot = await orderCollection.orderBy('time', descending: true).limit(limit).get();
        List<OrderModel> orderList = [];
        for (QueryDocumentSnapshot ordersDoc in ordersSnapshot.docs) {
          if (ordersDoc.exists) {
            final userData =
            OrderModel.fromJson(ordersDoc.data() as Map<String, dynamic>);
            print(userData);
            orderList.add(userData);
          }
          snapshot = ordersSnapshot;
        }
        return orderList;
    }
    } catch (e) {
      print('Error getting users list: $e');
      return [];
    }
  }

  Future<OrderModel?> getOrderData(String uid) async {
    try {
      DocumentSnapshot orderDoc = await orderCollection.doc(uid).get();
      if (orderDoc.exists) {
        final orderData =
        OrderModel.fromJson(orderDoc.data() as Map<String, dynamic>);
        print(orderData);
        return orderData;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  Future<void> deleteOrder(String uuid) async {
    try {
      DocumentReference orderDoc = orderCollection.doc(uuid);
      await orderDoc.delete();
    } catch (e) {
      print('Error deleting user account: $e');
    }
  }

  Future<void> editOrder(String uuid, OrderModel orderModel) async {
    try {
      DocumentReference orderDoc = orderCollection.doc(uuid);
      final order = jsonDecode(jsonEncode(orderModel.toJson()));
      await orderDoc.update(order);
      print('User ID: $uuid');
    } catch (e) {
      print('Error signing in anonymously: $e');
    }
  }

  Future<void> editStatus(String uuid, String status) async {
    try {
      DocumentReference orderDoc = orderCollection.doc(uuid);
      final order = jsonDecode(jsonEncode({"statusType": status}));
      await orderDoc.update(order);
      print('User ID: $uuid');
    } catch (e) {
      print('Error signing in anonymously: $e');
    }
  }

  Future<List<OrderModel>> getOrdersFilter(DateTime time) async {
    try {
        QuerySnapshot ordersSnapshot = await orderCollection.orderBy('time', descending: true).where('time', isGreaterThanOrEqualTo: Timestamp.fromDate(time)).get();
        List<OrderModel> orderList = [];
        print('ordersSnapshot: $ordersSnapshot');
        for (QueryDocumentSnapshot ordersDoc in ordersSnapshot.docs) {
          if (ordersDoc.exists) {
            final userData =
            OrderModel.fromJson(ordersDoc.data() as Map<String, dynamic>);
            print(userData);
            orderList.add(userData);
          }
        }
        print('Users list: $orderList');
        return orderList;
    } catch (e) {
      print('Error getting users list: $e');
      rethrow;
    }
  }

  Future<List<OrderModel>> getElementsYesterday() async {
    DateTime now = DateTime.now();
    DateTime yesterdayStart = DateTime(now.year, now.month, now.day - 1, 0, 0, 0, 0, 0);
    DateTime yesterdayEnd = DateTime(now.year, now.month, now.day, 0, 0, 0, 0, 0).subtract(Duration(milliseconds: 1));

    QuerySnapshot ordersSnapshot = await orderCollection.orderBy('time', descending: true)
        .where('time', isGreaterThanOrEqualTo: Timestamp.fromDate(yesterdayStart))
        .where('time', isLessThanOrEqualTo: Timestamp.fromDate(yesterdayEnd))
        .get();

    List<OrderModel> orderList = [];
    print('ordersSnapshot: $ordersSnapshot');
    for (QueryDocumentSnapshot ordersDoc in ordersSnapshot.docs) {
      if (ordersDoc.exists) {
        final userData =
        OrderModel.fromJson(ordersDoc.data() as Map<String, dynamic>);
        print(userData);
        orderList.add(userData);
      }
    }
    print('Users list: $orderList');
    return orderList;
  }
}
