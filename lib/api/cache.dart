import 'dart:convert';
import 'dart:html' as html;
import 'package:delivery/api/firestore_orders/dto.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cache {


  Future<void> savePhoto(List<ImageModel?> images) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encodedDataList = jsonEncode(images);
      prefs.remove('images');
      print(images.length);
      await prefs.setString('images', encodedDataList);
    } catch (e) {
      print(e);
    }
  }

  void deletePhoto() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('images');
  }

  Future<List<ImageModel>?> getPhoto() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encodedDataList = prefs.getString('images');

      if (encodedDataList == null) {
        return null;
      }

      final decodedDataList = jsonDecode(encodedDataList);

      if (decodedDataList is List) {
        final List<ImageModel> images = decodedDataList
            .map((data) => ImageModel.fromJson(data as Map<String, dynamic>))
            .toList();

        return images.isNotEmpty ? images : null;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
    // if (encodedDataList != null && encodedDataList.isNotEmpty) {
    //   final decodedDataList = encodedDataList
    //       .map((encodedData) => base64.decode(encodedData))
    //       .toList();
    //
    //   print(decodedDataList.length);
    //
    //   return decodedDataList.isNotEmpty ? decodedDataList : null;
    // } else {
    //   return null;
    // }
  }

// void saveImages(List<Uint8List?> dataList) {
  //   // final encodedData = base64.encode(Uint8List.fromList(
  //   //   dataList.expand<int>((list) => list ?? []).toList(),
  //   // ));
  //   var printableString = base64.encode(dataList.expand<int>((list) => list ?? []).toList());
  //  final cc = html.document.cookie =
  //   'images=$printableString; expires=${DateTime.now().add(const Duration(days: 30))}';
  //   print(cc);
  // }
  //
  // List<Uint8List> getCookie() {
  //   final cc = html.document.cookie;
  //   final cookieValue = html.document.cookie?.split(';').firstWhere(
  //         (cookie) => cookie.trimLeft().startsWith('images='),
  //     orElse: () => '',
  //   );
  //   print(cookieValue);
  //   if (cookieValue?.isNotEmpty ?? false) {
  //     final encodedData = Uri.decodeComponent(cookieValue?.split('=').last ?? '');
  //     final decodedData = base64.decode(encodedData);
  //     return [Uint8List.fromList(decodedData)];
  //   }
  //
  //   return [];
  // }

  // final DefaultCacheManager _cacheManager = DefaultCacheManager();
  //
  // Future<void> cacheImages(List<String> imageUrls) async {
  //   for (String imageUrl in imageUrls) {
  //     final Uint8List imageData = await getImageDataFromFirebase(imageUrl);
  //     final FileInfo fileInfo = await _cacheManager.putFileList([FileResponse(imageUrl, imageData)]);
  //     // fileInfo стане доступним для подальшого використання, якщо вам це потрібно
  //   }
  // }
  //
  // Future<Uint8List> getImageDataFromFirebase(String imageUrl) async {
  //   final file = await DefaultCacheManager().getSingleFile(imageUrl);
  //   return file.readAsBytes();
  // }
}
