import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradproject/repository/user_repository.dart';

class Relation {
  String userId1; //patient
  String userId2; //caregiver
  String? id;

  Relation({required this.userId1, required this.userId2, this.id});

  /// convert the relations to a map
  static Relation fromMapToRelations(Iterable<DataSnapshot> map) {
    var userId1 = '';
    var userId2 = '';
    String? id;
    for (var snapshot in map) {
      switch (snapshot.key) {
        case 'userId1':
          userId1 = snapshot.value.toString();
          break;
        case 'userId2':
          userId2 = snapshot.value.toString();
          break;
        case 'id':
          id = snapshot.value.toString();
          break;
        default:
          break;
      }
    }

    return Relation(
      userId1: userId1,
      userId2: userId2,
      id: id,
    );
  }

  // convert from relations to map
  static Map<String, dynamic> fromRelationsToMap(Relation data) {
    Map<String, dynamic> updateData = {
      'userId1': data.userId1,
      'userId2': data.userId2,
    };
    if (data.id != null) updateData['id'] = data.id;
    return updateData;
  }
}

// relations schema in firebase
// relations
//   - userId1
//   - userId2
class RelationRepository {
  final _database = FirebaseDatabase.instance;
  final _auth = FirebaseAuth.instance;
  Future<void> addRelation(String userId) async {
    // check if userId is in the database where user id is the key
    bool isUserExist = await UserRepository().checkUserExist(userId);
    if (!isUserExist) throw Exception('User is not exist');

    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final relation = Relation(userId1: currentUser.uid, userId2: userId);
      final relationMap = Relation.fromRelationsToMap(relation);
      await _database.ref().child('relations').push().set(relationMap);
    } else {
      throw Exception('User is not logged in');
    }
  }

  Future<Map<String, dynamic>> getRelationsForCurrentUser() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final relationsSnapshot = await _database
            .ref()
            .child('relations')
            .orderByChild('userId1')
            .equalTo(currentUser.uid)
            .get();
        final reversedRelationsSnapshot = await _database
            .ref()
            .child('relations')
            .orderByChild('userId2')
            .equalTo(currentUser.uid)
            .get();
        final List<Relation> relations = [];
        final List<String> relationsId = [];
        relationsSnapshot.children.forEach((element) {
          String id = element.key.toString();
          final relation = Relation(
              userId1: element.child('userId1').value.toString(),
              userId2: element.child('userId2').value.toString(),
              id: element.key.toString());
          relations.add(relation);
          relationsId.add(id);
        });
        reversedRelationsSnapshot.children.forEach((element) {
          String id = element.key.toString();
          final relation = Relation(
              userId1: element.child('userId2').value.toString(),
              userId2: element.child('userId1').value.toString(),
              id: element.key.toString());
          relations.add(relation);
          relationsId.add(id);
        });
        return {'relations': relations, 'relationsId': relationsId};
      }
      return {'relations': [], 'relationsId': []};
    } catch (e) {
      throw Exception('Error while getting relations');
    }
  }

  Future<bool> checkRelationExist(String userId) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final relationsSnapshot = await _database
          .ref()
          .child('relations')
          .orderByChild('userId1')
          .equalTo(currentUser.uid)
          .get();
      final reversedRelationsSnapshot = await _database
          .ref()
          .child('relations')
          .orderByChild('userId2')
          .equalTo(currentUser.uid)
          .get();
      final List<Relation> relations = [];
      relationsSnapshot.children.forEach((element) {
        final relation = Relation(
            userId1: element.child('userId1').value.toString(),
            userId2: element.child('userId2').value.toString(),
            id: element.key.toString());
        relations.add(relation);
      });
      reversedRelationsSnapshot.children.forEach((element) {
        final relation = Relation(
            userId1: element.child('userId2').value.toString(),
            userId2: element.child('userId1').value.toString(),
            id: element.key.toString());
        relations.add(relation);
      });
      for (var relation in relations) {
        if (relation.userId2 == userId) return true;
      }
      return false;
    }
    return false;
  }

  Future<void> deleteRelation(String relationId) async {
    try {
      await _database.ref().child('relations').child(relationId).remove();
    } catch (e) {
      throw Exception('Error while deleting relation');
    }
  }
}
