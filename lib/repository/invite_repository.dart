import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradproject/repository/notification_repository.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gradproject/utils/has_network.dart';
import 'dart:convert';
import 'package:gradproject/repository/user_repository.dart';

enum InviteStatus { pending, accepted, rejected }

class Invites {
  // invites have some properties, 1-notificationID, 2-inviteStatus, 3-inviteSenderID, 4-inviteReceiverID
  InviteStatus? inviteStatus;
  String inviteSenderID;
  String inviteReceiverID;

  Invites({
    required this.inviteSenderID,
    required this.inviteReceiverID,
    this.inviteStatus = InviteStatus.pending,
  });
  static Invites fromMapToInvites(String? id, Iterable<DataSnapshot> map) {
    var inviteStatus = InviteStatus.pending;
    var inviteSenderID = '';
    var inviteReceiverID = '';
    for (var snapshot in map) {
      switch (snapshot.key) {
        case 'inviteStatus':
          inviteStatus = snapshot.value.toString() == 'pending'
              ? InviteStatus.pending
              : snapshot.value.toString() == 'accepted'
                  ? InviteStatus.accepted
                  : InviteStatus.rejected;
          break;
        case 'inviteSenderID':
          inviteSenderID = snapshot.value.toString();
          break;
        case 'inviteReceiverID':
          inviteReceiverID = snapshot.value.toString();
          break;
      }
    }
    return Invites(
      inviteStatus: inviteStatus,
      inviteSenderID: inviteSenderID,
      inviteReceiverID: inviteReceiverID,
    );
  }

  static Map<String, dynamic> fromInvitesToMap(Invites data) {
    Map<String, dynamic> updateData = {
      'inviteStatus': data.inviteStatus?.toString(),
      'inviteSenderID': data.inviteSenderID,
      'inviteReceiverID': data.inviteReceiverID,
    };
    return updateData;
  }
}

class InvitesRepository {
  final _invitesRef = FirebaseDatabase.instance.ref().child('invites');
  User? user = FirebaseAuth.instance.currentUser;

  // create invite function, first create an push a notification using pushNotificationToUser function, then create an invite with the notificationID
  Future<void> createInvitation(String receiverId) async {
    // first let's make sure that the user is logged in and the receiverId is in users table, thorw an error if not
    if (user == null) throw Exception('User is not logged in');
    if (!await UserRepository().checkUserExist(receiverId)) {
      throw Exception('User does not exist');
    }
    UserProfile userInfo = await UserRepository().getUserProfile();
    // second let's create the invitation
    final invite = Invites(
      inviteSenderID: user!.uid,
      inviteReceiverID: receiverId,
    );
    final newInvitation = _invitesRef.push();
    await newInvitation.set(Invites.fromInvitesToMap(invite));
    String id = newInvitation.key!;

    // third let's create the notification
    final result =
        await NotificationRepository().pushNotificationToUser(Notification(
      targetUserID: receiverId,
      senderUserID: user!.uid,
      notificationType: 'invite',
      notificationTypeId: id,
      title: "you have a new invitation",
      body: "${userInfo.username} wants to add you to their caregiver list",
    ));
    if (!result['success']) {
      throw Exception('Failed to send notification but invite was created');
    }
  }

  //
}
