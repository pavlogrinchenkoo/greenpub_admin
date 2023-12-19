import 'package:delivery/api/firestore_tags/dto.dart';

abstract class TagsState {}

class LoadingState extends TagsState {}

class LoadedState extends TagsState {
  final List<TagModel>? tags;

  LoadedState({ this.tags});
}

class ErrorState extends TagsState {}