import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:delivery/api/firestore_category/dto.dart';
import 'package:delivery/api/firestore_category/request.dart';
import 'package:delivery/api/firestore_product/dto.dart';
import 'package:delivery/api/firestore_product/request.dart';
import 'package:delivery/api/firestore_tags/dto.dart';
import 'package:delivery/api/firestore_tags/request.dart';
import 'package:delivery/routers/routes.dart';
import 'package:delivery/screens/products_page/bloc/bloc.dart';
import 'package:delivery/widgets/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:uuid/uuid.dart';
import 'state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  final FirestoreProductApi firestoreApi;
  final FirestoreCategoryApi firestoreCategoryApi;
  final FirestoreTagsApi firestoreTagsApi;
  var uuid = const Uuid();

  AddProductCubit(
      this.firestoreApi, this.firestoreCategoryApi, this.firestoreTagsApi)
      : super(LoadingState());

  File? imageFile;
  String? id;
  String? time;
  bool isPromo = false;
  Uint8List? image;
  String? imagePath;
  CategoryModel? category;
  List<TagModel>? tags = [];
  List<CategoryModel> categoryList = [];
  List<TagModel> tagsList = [];

  Future<void> init(BuildContext context) async {
    try {
      emit(LoadingState());
      id = uuid.v1();
      final time = DateTime.now();
      final tagsList = await firestoreTagsApi.getTagsList();
      final categoryList = await firestoreCategoryApi.getCategoriesList();
      this.tagsList = tagsList;
      this.categoryList = categoryList;
      this.time = '${time.day}.${time.month}.${time.year}';
      emit(LoadedState(
          time: this.time,
          id: id,
          categoryList: this.categoryList,
          tagsList: this.tagsList));
    } catch (e) {
      emit(ErrorState());
    }
  }

  void addTegs(List<TagModel> tags) {
    this.tags = tags;
    print(this.tags);
  }

  void addCategory(CategoryModel? category) {
    this.category = category;
    print(this.category);
  }

  void changePromo() {
    isPromo = !isPromo;
    emit(LoadedState(
        id: id,
        time: time,
        image: image,
        imagePath: imagePath,
        categoryList: categoryList,
        tagsList: tagsList));
  }

  Future<void> addProduct(BuildContext context,
      {String? name,
      String? price,
      String? newPrice,
      CategoryModel? category,
      String? description,
      String? weight,
      String? time,
      bool? isPromo,
      String? imagePath,
      String? uuid,
      List<TagModel>? tags}) async {
    try {
      final dTime = DateTime.now();
      final numPrice = double.tryParse(price ?? '0') ?? 0;
      final numNewPrice = double.tryParse(newPrice ?? '0') ?? 0;
      // final numWeight = int.tryParse(weight ?? '0') ?? 0;
      final time = '${dTime.day}.${dTime.month}.${dTime.year}';
      final product = ProductModel(
        uuid: uuid,
        name: name,
        price: numPrice,
        oldPrice: numNewPrice,
        category: category,
        description: description,
        weight: weight,
        timeCreate: time,
        isPromo: isPromo,
        tags: tags,
        image: imagePath,
      );
      emit(LoadingState());
      await firestoreApi.addProduct(product);
      if (context.mounted) {
        context.router
            .pop()
            .whenComplete(() => context.read<ProductsCubit>().init(context));
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarService.showSnackBar(
            context, 'Не вдалось додати продукт', true);
      }
    }
  }

  Future<void> uploadFile() async {
    try {
      final Uint8List? pickedFile = await ImagePickerWeb.getImageAsBytes();
      final imagePath = await firestoreApi.saveImage(pickedFile, id ?? '');
      image = pickedFile;
      this.imagePath = imagePath;
      emit(LoadedState(
          categoryList: categoryList,
          tagsList: tagsList,
          id: id,
          time: time,
          image: pickedFile,
          imagePath: imagePath));
    } catch (e) {
      print('Error picking image: $e');
    }
  }
}
