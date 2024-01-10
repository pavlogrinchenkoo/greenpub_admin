import 'package:auto_route/auto_route.dart';
import 'package:delivery/api/firestore_shared/dto.dart';
import 'package:delivery/api/firestore_shared/request.dart';
import 'package:delivery/routers/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:uuid/uuid.dart';
import 'state.dart';

class SharesCubit extends Cubit<SharesState> {
  final SharedApi sharedApi;

  SharesCubit(this.sharedApi) : super(LoadingState());
  final uuid = Uuid();
  String uid = '';
  bool isAddShared = false;
  List<SharesModel> shares = [];
  List<Uint8List?> images = [];
  SharesModel? shared;
  Uint8List? image;
  String? imagePath;
  int index = 0;

  Future<void> init(BuildContext context) async {
    try {
      images = [];
      index = 0;
      isAddShared = false;
      uid = '';
      image = null;
      imagePath = null;
      this.shares = [];
      emit(LoadingState());
      final shares = await sharedApi.getSharesList();
      this.shares.addAll(shares);
      await getImages();
      shared = shares[index];
      image = images[index];
      emit(LoadedState(shares: shares));
    } catch (e) {
      emit(ErrorState());
    }
  }

  void selectIndex(int index) async {
    shared = shares[index];
    this.index = index;
    image = images[index];
    isAddShared = false;
    emit(LoadedState(shares: shares));
  }

  Future<void> getImages() async {
    for (final share in shares) {
      final image = await sharedApi.getImage(share.image ?? '');
      images.add(image);
    }
    emit(LoadedState(shares: shares));
  }

  void changeIsAddShared() {
    isAddShared = true;
    shared = null;
    image = null;
    uid = uuid.v1();
    emit(LoadedState(shares: shares));
  }

  void addShares(String title, String description, String image,
      BuildContext context) async {
    final shares = SharesModel(
      uid: uid,
      title: title,
      description: description,
      image: image,
    );
    await sharedApi.addShares(shares);
    if (context.mounted) init(context);
    isAddShared = false;
  }

  Future<void> editShared(String title, String description, String image,
      BuildContext context) async {
    print(image);
    final shares = SharesModel(
      uid: shared?.uid ?? '',
      title: title,
      description: description,
      image: (imagePath != null) ? image : shared?.image ?? '',
    );
    await sharedApi.editShares(shared?.uid ?? '', shares);
    if (context.mounted) init(context);
    isAddShared = false;
  }

  Future<void> deleteShares(BuildContext context) async {
    await sharedApi.deleteShared(shared?.uid ?? '');
    await sharedApi.deleteImage(shared?.image ?? '');
    if (context.mounted) init(context);
  }

  Future<void> uploadImage() async {
    try {
      if(shared != null){
        uid = shared?.uid ?? '';
      }
      final Uint8List? pickedFile = await ImagePickerWeb.getImageAsBytes();
      sharedApi.deleteImage(uid ?? '');
      final imagePath = await sharedApi.saveImage(pickedFile, uid ?? '');
      image = pickedFile;
      this.imagePath = imagePath;
      emit(LoadedState(shares: shares));
    } catch (e) {
      print('Error picking image: $e');
    }
  }
}
