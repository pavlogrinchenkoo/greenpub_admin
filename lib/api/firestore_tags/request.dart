import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/api/firestore_tags/dto.dart';
import 'package:uuid/uuid.dart';

class FirestoreTagsApi {
  final Uuid uuid = const Uuid();
  CollectionReference tagsCollection =
      FirebaseFirestore.instance.collection('tags');

  Future<List<TagModel>> getTagsList() async {
    try {
      QuerySnapshot tagsSnapshot = await tagsCollection.get();
      List<TagModel> tagsList = [];

      for (QueryDocumentSnapshot tagsDoc in tagsSnapshot.docs) {
        if (tagsDoc.exists) {
          final tegData =
              TagModel.fromJson(tagsDoc.data() as Map<String, dynamic>);
          tagsList.add(tegData);
        }
      }
      print('tags list: $tagsList');
      return tagsList;
    } catch (e) {
      print('Error getting tags list: $e');
      return [];
    }
  }

  Future<void> addTag(String tag) async {
    try {
      String uid = uuid.v1();
      TagModel tags = TagModel(uuid: uid, tag: tag);

      DocumentReference tagDoc = tagsCollection.doc(uid);
      await tagDoc.set(tags.toJson());
      print('User ID: $uid');
    } catch (e) {
      print('Error signing in anonymously: $e');
    }
  }

  Future<void> editTag(String uuid, String newTag) async {
    try {
      DocumentReference productDoc = tagsCollection.doc(uuid);
      await productDoc.update({
        'tag': newTag,
      });
      print('User ID: $uuid');
    } catch (e) {
      print('Error signing in anonymously: $e');
    }
  }

  Future<void> deleteTag(String uuid) async {
    try {
      DocumentReference userDoc = tagsCollection.doc(uuid);
      await userDoc.delete();
    } catch (e) {
      print('Error deleting user account: $e');
    }
  }
}
