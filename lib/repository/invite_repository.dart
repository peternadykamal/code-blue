import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class inviteRepository {
  final DatabaseReference _invitesRef =
      FirebaseDatabase.instance.ref().child('invites');
  User user = FirebaseAuth.instance.currentUser!;

  Future<void> sendInvitation(String recipientId) async {
    final invitationRef = _invitesRef.push();

    final invitation = <String, dynamic>{
      'senderId': user.uid,
      'recipientId': recipientId,
      'status': 'pending',
      'createdAt': ServerValue.timestamp,
    };

    await invitationRef.set(invitation);
  }
}
// TODO: we need to find a way to push notifications to the other user when they receive an invite