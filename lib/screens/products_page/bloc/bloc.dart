import 'package:auto_route/auto_route.dart';
import 'package:delivery/api/cache.dart';
import 'package:delivery/api/firestore_product/dto.dart';
import 'package:delivery/api/firestore_product/request.dart';
import 'package:delivery/routers/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final FirestoreProductApi firestoreApi;
  final Cache cache;

  ProductsCubit(this.firestoreApi, this.cache) : super(LoadingState());

  List<ProductModel> products = [];
  bool isLoadMoreTriggered = false;
  bool isAll = false;
  int count = 0;
  List<Uint8List?> images = [];

  Future<void> init(BuildContext context) async {
    try {
      emit(LoadingState());
      final products = await firestoreApi.getProductsList(50);
      print(products);
      this.products = products;
      count = products.length;
      final cachedImages = await cache.getPhoto();
      print(cachedImages?.length);
      print((cachedImages?.length ?? 0) < products.length);
      if (cachedImages == null ||
          (cachedImages?.length ?? 0) < products.length) {
        for (final product in products) {
          final image = product.image;
          final getImage = await firestoreApi.getImage(image ?? '');
          images.add(getImage);
        }
        await cache.savePhoto(images);
      } else {
        images = cachedImages;
      }

      emit(LoadedState(products: products, images: images));
    } catch (e) {
      emit(ErrorState());
    }
  }

  Future<void> getProducts() async {
    try {
      if (count >= 50) {
        final products = await firestoreApi.getProductsList(50);
        this.products.addAll(products);
        for (final product in products) {
          final image = product.image;
          final getImage = await firestoreApi.getImage(image ?? '');
          images.add(getImage);
        }
        emit(LoadedState(products: this.products, images: images));
        count = products.length;
      }
    } catch (e) {
      emit(ErrorState());
    }
  }

  void goAddProductPage(BuildContext context) {
    context.router.push(const AddProductRoute());
  }

  void goProductPage(BuildContext context, String id) {
    context.router.push(ProductRoute(id: id));
  }

  void dispose() {
    count = 0;
    products = [];
    isLoadMoreTriggered = false;
    isAll = false;
  }
}
