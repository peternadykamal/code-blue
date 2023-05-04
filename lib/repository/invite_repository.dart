import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradproject/repository/notification_repository.dart';
import 'package:gradproject/repository/relation_repository.dart';
import 'package:gradproject/repository/user_repository.dart';

enum InviteStatus { pending, accepted, rejected }

class Invite {
  // invites have some properties, 1-notificationID, 2-inviteStatus, 3-inviteSenderID, 4-inviteReceiverID
  InviteStatus? inviteStatus;
  String inviteSenderID;
  String inviteReceiverID;

  Invite({
    required this.inviteSenderID,
    required this.inviteReceiverID,
    this.inviteStatus = InviteStatus.pending,
  });
  static Invite fromMapToInvites(Iterable<DataSnapshot> map) {
    var inviteStatus = InviteStatus.pending;
    var inviteSenderID = '';
    var inviteReceiverID = '';
    for (var snapshot in map) {
      switch (snapshot.key) {
        case 'inviteStatus':
          inviteStatus = InviteStatus.values[snapshot.value as int];
          break;
        case 'inviteSenderID':
          inviteSenderID = snapshot.value.toString();
          break;
        case 'inviteReceiverID':
          inviteReceiverID = snapshot.value.toString();
          break;
      }
    }
    return Invite(
      inviteStatus: inviteStatus,
      inviteSenderID: inviteSenderID,
      inviteReceiverID: inviteReceiverID,
    );
  }

  static Map<String, dynamic> fromInvitesToMap(Invite data) {
    Map<String, dynamic> updateData = {
      'inviteStatus': data.inviteStatus?.index,
      'inviteSenderID': data.inviteSenderID,
      'inviteReceiverID': data.inviteReceiverID,
    };
    return updateData;
  }
}

class InviteRepository {
  final _invitesRef = FirebaseDatabase.instance.ref().child('invites');
  User? user = FirebaseAuth.instance.currentUser;

  // create invite function
  Future<void> createInvitation(String receiverId) async {
    // first let's make sure that the user is logged in and the receiverId is in users table, thorw an error if not
    if (user == null) throw Exception('User is not logged in');
    if (!await UserRepository().checkUserExist(receiverId)) {
      throw Exception('User does not exist');
    }

    // check if the user is trying to add himself, if so, throw an error
    if (user!.uid == receiverId) {
      throw Exception('You cannot add yourself');
    }

    // check if there is a relation between the two users, if there is one, throw an error
    if (await RelationRepository().checkRelationExist(receiverId)) {
      throw Exception('they already become your caregiver');
    }

    // check if there is an invite with the same user and receiver, if there is one and with status pending or accepted, throw an error
    DataSnapshot invites = await _invitesRef
        .orderByChild('inviteSenderID')
        .equalTo(user!.uid)
        .get();
    if (invites.value != null) {
      for (var invite in invites.children) {
        // convert it to an invite object
        final inviteObj = Invite.fromMapToInvites(invite.children);
        if (inviteObj.inviteReceiverID == receiverId &&
            inviteObj.inviteStatus == InviteStatus.pending) {
          throw Exception('Invite already exists and is pending');
        }
      }
    }
    invites = await _invitesRef
        .orderByChild('inviteReceiverID')
        .equalTo(user!.uid)
        .get();
    if (invites.value != null) {
      for (var invite in invites.children) {
        // convert it to an invite object
        final inviteObj = Invite.fromMapToInvites(invite.children);
        if (inviteObj.inviteSenderID == receiverId &&
            inviteObj.inviteStatus == InviteStatus.pending) {
          throw Exception('Invite already exists and is pending');
        }
      }
    }

    UserProfile userInfo = await UserRepository().getUserProfile();
    // second let's create the invitation
    final invite = Invite(
      inviteSenderID: user!.uid,
      inviteReceiverID: receiverId,
    );
    final newInvitation = _invitesRef.push();
    await newInvitation.set(Invite.fromInvitesToMap(invite));
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

  // accept invite function, first update the invite status to accepted, then add a relation between the two users in the relations table
  Future<void> acceptInvitation(String inviteId) async {
    // first let's make sure that the user is logged in and the inviteId is in invites table, throw an error if not
    if (user == null) throw Exception('User is not logged in');
    if (!await checkInviteExist(inviteId)) {
      throw Exception('Invite does not exist');
    }

    // second check if invite status is pending, if not throw an error
    Invite invite = await getInviteById(inviteId);
    if (invite.inviteStatus != InviteStatus.pending) {
      throw Exception('Invite is not pending');
    }

    // third let's update the invite status
    await _invitesRef.child(inviteId).update({
      'inviteStatus': InviteStatus.accepted.index,
    });

    // forth let's add a relation between the two users
    await RelationRepository().addRelation(invite.inviteSenderID);
  }

  // reject invite function, first update the invite status to rejected
  Future<void> rejectInvitation(String inviteId) async {
    // first let's make sure that the user is logged in and the inviteId is in invites table, throw an error if not
    if (user == null) throw Exception('User is not logged in');
    if (!await checkInviteExist(inviteId)) {
      throw Exception('Invite does not exist');
    }

    // second check if invite status is pending, if not throw an error
    Invite invite = await getInviteById(inviteId);
    if (invite.inviteStatus != InviteStatus.pending) {
      throw Exception('Invite is not pending');
    }

    // third let's update the invite status
    await _invitesRef.child(inviteId).update({
      'inviteStatus': InviteStatus.rejected.index,
    });
  }

  Future<bool> checkInviteExist(String inviteId) async {
    final snapshot = await _invitesRef.child(inviteId).get();
    return snapshot.value != null;
  }

  Future<Invite> getInviteById(String inviteId) async {
    final snapshot = await _invitesRef.child(inviteId).get();
    return Invite.fromMapToInvites(snapshot.children);
  }

  Future<void> updateInviteStatus(String inviteId, InviteStatus status) async {
    await _invitesRef.child(inviteId).update({
      'inviteStatus': status.index,
    });
  }
}
