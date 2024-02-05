import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:delivery/api/system/dto.dart';
import 'package:delivery/api/system/request.dart';
import 'package:delivery/routers/routes.dart';
import 'package:delivery/screens/system_page/widgets/send_message.dart';
import 'package:delivery/screens/system_page/widgets/show_edit.dart';
import 'package:delivery/style.dart';
import 'package:delivery/widgets/custom_show_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';

class SystemCubit extends Cubit<SystemState> {
  final SystemApi _systemApi;

  SystemCubit(this._systemApi) : super(LoadingState());

  Future<void> init(BuildContext context) async {
    try {
      emit(LoadingState());
      final system = await _systemApi.getSystem();
      emit(LoadedState(
        system: system,
      ));
    } catch (e) {
      emit(ErrorState());
    }
  }

  void showEdit(BuildContext context, SystemModel? system) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '',
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: BDuration.d500,
        pageBuilder: (pageContext, _, __) {
          return Material(
              child: ShowEdit(
            system: system,
          ));
        });
  }

  Future<void> saveSystem(BuildContext context, SystemModel system) async {
    try {
      await _systemApi.saveSystem(system);
      if (context.mounted) {
        context.router.pop();
        await init(context);
      }
    } catch (e) {
      print(e);
    }
  }

  void showModal(BuildContext context) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '',
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: BDuration.d500,
        pageBuilder: (pageContext, _, __) {
          return Material(child: SendMessage());
        });
  }

  void showDialogSend(BuildContext context, String title, String msg, String id) {
    showDialog(context: context, builder: (context) {
      return CustomShowDialog(
        title: 'Пуш повідомлення',
        content: 'Ви впевнені що хочете надіслати повідомлення?',
        onTapOne: () {
           sendNotification(
             title: title,
             msg: msg,
             id: id
           );
           context.router.pop().whenComplete(() => context.router.pop());
        },
        onTapTwo: () {
          context.router.pop();
        },
        buttonOne: 'Так',
        buttonTwo: 'Ні',
      );
    });
  }

  sendNotification({String? title, String? msg, String? id}) async {
    if (title == null || msg == null) return;

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic MzU1ZDZhZmQtNzc0Yi00ZTM2LWFhMzQtYmRhZDI5ZDMwZThk',
    };
    final data = json.encode({
      "app_id": "a488ebc0-eb85-43c2-a4dc-b8b84e57c9b6",
      "included_segments": ["All"],
      "data": {"id": id ?? ''},
      "headings": {"en": title},
      "contents": {"en": msg}
    });
    final dio = Dio();
    final response = await dio.request(
      'https://onesignal.com/api/v1/notifications',
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      print(json.encode(response.data));
    } else {
      print(response.statusMessage);
    }
  }
}
