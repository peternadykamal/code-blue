import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradproject/repository/notification_repository.dart'
    as notifyRepo;
import 'package:gradproject/repository/request_repository.dart';
import 'package:gradproject/repository/invite_repository.dart';
import 'package:gradproject/sos.dart';
import 'package:gradproject/style.dart';
import 'package:gradproject/utils/has_network.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gradproject/utils/has_network.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<dynamic> _notificationsObjects = [];
  List<notifyRepo.Notification> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final notifications =
        await notifyRepo.NotificationRepository().getNotifications();
    setState(() {
      _notificationsObjects = notifications['notificationsObjects'];
      _notifications = notifications['notifications'];
      notifyRepo.NotificationRepository().markAllNotificationsAsSeen();
    });
  }

  Widget _buildNotification(
      BuildContext context, notifyRepo.Notification notification) {
    final index = _notifications.indexOf(notification);
    final notificationObject = _notificationsObjects[index];

    if (notification.notificationType == 'invite') {
      final invite = notificationObject as Invite;
      if (invite.inviteStatus == InviteStatus.pending) {
        return ListTile(
          leading: Icon(Icons.people),
          title: Text(_notifications[index].title),
          subtitle: Text(_notifications[index].body),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  try {
                    InviteRepository().acceptInvitation(
                      _notifications[index].notificationTypeId,
                    );
                    setState(() {
                      invite.inviteStatus = InviteStatus.accepted;
                    });
                  } catch (e) {
                    Fluttertoast.showToast(
                      msg: e.toString(),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Mycolors.buttoncolor,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  try {
                    InviteRepository().rejectInvitation(
                      _notifications[index].notificationTypeId,
                    );
                    setState(() {
                      invite.inviteStatus = InviteStatus.rejected;
                    });
                  } catch (e) {
                    Fluttertoast.showToast(
                      msg: e.toString(),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Mycolors.buttoncolor,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                },
              ),
            ],
          ),
        );
      } else {
        return ListTile(
          leading: Icon(Icons.people),
          title: Text(_notifications[index].title),
          subtitle: Text(_notifications[index].body),
          trailing: invite.inviteStatus == InviteStatus.accepted
              ? Icon(Icons.check)
              : Icon(Icons.close),
        );
      }
    } else if (notification.notificationType == 'request') {
      final request = notificationObject as Request;
      return ListTile(
        leading: Icon(Icons.local_hospital),
        title: Text(request.patient),
        subtitle: Text('Requested your help'),
        onTap: () {
          final url =
              'https://www.google.com/maps/search/?api=1&query=${request.latitude},${request.longitude}';
          // convert url to a uri to be able to launch it
          final uri = Uri.parse(url);
          launchUrl(uri);
        },
      );
    } else {
      return ListTile(
        leading: Icon(Icons.notifications),
        title: Text(notification.title),
        subtitle: Text(notification.body),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Do something here
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => sosPage()));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
        ),
        body: ListView.builder(
          itemCount: _notifications.length,
          itemBuilder: (context, index) {
            final notification = _notifications[index];
            return _buildNotification(context, notification);
          },
        ),
      ),
    );
  }
}
