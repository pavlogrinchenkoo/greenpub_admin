import 'package:auto_route/auto_route.dart';
import 'package:delivery/api/firestore_product/dto.dart';
import 'package:delivery/api/firestore_product/request.dart';
import 'package:delivery/api/positions/dto.dart';
import 'package:delivery/api/positions/request.dart';
import 'package:delivery/routers/routes.dart';
import 'package:delivery/screens/positions_page/bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'state.dart';

class PositionCubit extends Cubit<PositionState> {
  final PositionApi positionApi;
  final FirestoreProductApi firestoreApi;
  final Uuid uuid = const Uuid();
  PositionCubit(this.positionApi, this.firestoreApi) : super(LoadingState());

  List<ProductModelPosition>? positions = [];
  List<ProductModel> searchSauces = [];
  PositionGroupModel? positionGroupModel;
  List<ProductModel>? sauces = [];
  bool isSearch = false;
  bool required = false;

  Future<void> init(
      PositionGroupModel? position, TextEditingController controller) async {
    try {
      emit(LoadingState());
      if (position != null) {
        final getPosition = await firestoreApi.getProductsOption(position.positions ?? []);
        positionGroupModel = position;
        positions = getPosition;
        required = position.required ?? false;
        controller.text = position.name ?? '';
      }
      final sauces = await firestoreApi.getProducts();
      this.sauces = sauces;
      searchSauces = sauces;
      emit(LoadedState(
        sauces: sauces, positions: positions,
        // position: position
      ));
    } catch (e) {
      emit(ErrorState());
    }
  }

  Future<void> searchProduct(String query) async {
    try {
      if(query.isEmpty) {
        isSearch = false;
      } else {
        isSearch = true;
      }
      searchSauces = [];
      searchSauces = sauces!.where((element) => element.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      print(searchSauces);
      if(searchSauces.isEmpty) {
        searchSauces = sauces ?? [];
      }
      emit(LoadedState(
        positions: positions,
        sauces: searchSauces,
      ));
    } catch (e) {
      emit(ErrorState());
    }
  }

  void addSauce(ProductModel? sauce) {
    final position = ProductModelPosition(
      uuid: sauce?.uuid,
      oldPrice: sauce?.oldPrice,
      price: sauce?.price,
      isPromo: sauce?.isPromo,
      category: sauce?.category,
      tags: sauce?.tags,
      image: sauce?.image,
      name: sauce?.name,
      description: sauce?.description,
      weight: sauce?.weight,
      timeCreate: sauce?.timeCreate,
      required: false,
    );
    positions?.add(position);
    print(positions?.length);
    emit(LoadedState(sauces: searchSauces, positions: positions));
  }

  void removeSauce(String? uuid) {
    positions?.removeWhere((element) => element.uuid == uuid);
    emit(LoadedState(sauces: searchSauces, positions: positions));
  }

  // void editSauce(String? uuid) {
  //   final required =
  //       positions?.where((element) => element.uuid == uuid).first.required;
  //   positions?.where((element) => element.uuid == uuid).first.required =
  //       !(required ?? false);
  //   emit(LoadedState(sauces: sauces, positions: positions));
  // }


  void savePosition(String? name, BuildContext context) async {
    final positionString = positions?.map((e) => e.uuid ?? '').toList();
    if(positionGroupModel != null){

      final positionGroupModel = PositionGroupModel(
          uuid: this.positionGroupModel?.uuid,
          name: name, positions: positionString, required: false);
      await positionApi.editPosition(positionGroupModel);
    } else {
   final positionGroupModel = PositionGroupModel(
          uuid: uuid.v1(),
          name: name, positions: positionString, required: false);
      await positionApi.addPosition(positionGroupModel);

    }

    if (context.mounted) {
      context.router
          .pop()
          .whenComplete(() => context.read<PositionsCubit>().init(context));
    }
  }

  void dispose() {
    positionGroupModel = null;
    required = false;
    positions = [];
    sauces = [];
  }
}
