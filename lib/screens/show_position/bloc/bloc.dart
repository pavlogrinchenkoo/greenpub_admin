import 'package:auto_route/auto_route.dart';
import 'package:delivery/api/firestore_product/dto.dart';
import 'package:delivery/api/firestore_product/request.dart';
import 'package:delivery/routers/routes.dart';
import 'package:delivery/screens/product_page/bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';

class ShowPositionCubit extends Cubit<ShowPositionState> {
  final FirestoreProductApi firestoreApi;

  ShowPositionCubit(this.firestoreApi) : super(LoadingState());

  List<ProductModelPosition>? positions = [];
  List<ProductModel>? sauces = [];
  bool required = false;

  Future<void> init(PositionGroupModel? position, TextEditingController controller) async {
    try {
      emit(LoadingState());
      if(position != null){
        positions = position.positions;
        required = position.required ?? false;
        controller.text = position.name ?? '';
      }
      final sauces = await firestoreApi.searchProductsSauces();
      for (final sauce in sauces) {
        if (sauce.category?.uuid == 'ebc7dc00-0a3e-1dfc-960e-83d41c06d6e2') {
          this.sauces?.add(sauce);
        }
      }
      emit(LoadedState(sauces: sauces, positions: positions, position: position));
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
    emit(LoadedState(sauces: sauces, positions: positions));
  }

  void removeSauce(String? uuid) {
    positions?.removeWhere((element) => element.uuid == uuid);
    emit(LoadedState(sauces: sauces, positions: positions));
  }

  void editSauce(String? uuid) {
    final required =
        positions?.where((element) => element.uuid == uuid).first.required;
    positions?.where((element) => element.uuid == uuid).first.required =
        !(required ?? false);
    emit(LoadedState(sauces: sauces, positions: positions));
  }

  void editPosition() {
    required = !required;
    emit(LoadedState(sauces: sauces, positions: positions));
  }

  void savePosition(String? name, BuildContext context) {
    final positionGroup = PositionGroupModel(
        name: name, positions: positions, required: required);
    context.read<ProductCubit>().savePosition(positionGroup);
    context.router.pop();
  }

  void dispose() {
    positions = [];
    sauces = [];
  }
}
