import 'package:easy_localization/easy_localization.dart';
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
    });
  }

  Widget _buildNotification(
      BuildContext context, notifyRepo.Notification notification) {
    final index = _notifications.indexOf(notification);
    final notificationObject = _notificationsObjects[index];
    final isUnseen = !notification.isSeen;
    final dateFromNow = DateTime.now().difference(notification.date!);
// format date from now if less than 24 hours else in days
    String date = dateFromNow.abs().inDays >= 1
        ? '${dateFromNow.abs().inDays}d'
        : dateFromNow.abs().inHours >= 1
            ? '${dateFromNow.abs().inHours}h'
            : '${dateFromNow.abs().inMinutes}m';

    if (notification.notificationType == 'invite') {
      final invite = notificationObject as Invite;
      if (invite.inviteStatus == InviteStatus.pending) {
        return Card(
          margin: EdgeInsets.only(right: 10, left: 10, bottom: 5, top: 5),
          color: Mycolors.numpad,
          elevation: 4,
          child: ListTile(
            leading: Stack(
              children: [
                Icon(Icons.notifications, color: Mycolors.textcolor),
                if (!notification.isSeen)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            title: Text(
              _notifications[index].title,
              style: TextStyle(
                  color: Mycolors.textcolor, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_notifications[index].body),
                Text(
                  '${date}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.check, color: Mycolors.textcolor),
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
                  icon: Icon(Icons.close, color: Mycolors.textcolor),
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
          ),
        );
      } else {
        return Card(
          margin: EdgeInsets.only(right: 10, left: 10, bottom: 5, top: 5),
          color: Mycolors.numpad,
          elevation: 4,
          child: ListTile(
            leading: Icon(Icons.people, color: Mycolors.textcolor),
            title: Text(
              _notifications[index].title,
              style: TextStyle(
                  color: Mycolors.textcolor, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_notifications[index].body),
                Text(
                  '${date}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            trailing: invite.inviteStatus == InviteStatus.accepted
                ? Icon(Icons.check, color: Mycolors.textcolor)
                : Icon(Icons.close, color: Mycolors.textcolor),
          ),
        );
      }
    } else if (notification.notificationType == 'request') {
      final request = notificationObject as Request;
      return Card(
        margin: EdgeInsets.only(right: 10, left: 10, bottom: 5, top: 5),
        color: Mycolors.numpad,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Stack(
              children: [
                Icon(Icons.local_hospital, color: Mycolors.textcolor),
                if (isUnseen)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            title: Text(
              request.patient,
              style: TextStyle(
                  color: Mycolors.textcolor, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Requested your help'),
                Text(
                  '${date}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            onTap: () {
              final url =
                  'https://www.google.com/maps/search/?api=1&query=${request.latitude},${request.longitude}';
              // convert url to a uri to be able to launch it
              final uri = Uri.parse(url);
              launchUrl(uri);
            },
          ),
        ),
      );
    } else {
      return ListTile(
        leading: Icon(Icons.notifications),
        title: Text(
          notification.title,
          style:
              TextStyle(color: Mycolors.textcolor, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(notification.body),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        notifyRepo.NotificationRepository().markAllNotificationsAsSeen();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => sosPage()));
        return false;
      },
      child: Scaffold(
        backgroundColor: Mycolors.fillingcolor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Mycolors.splashback,
          bottomOpacity: 0.0,
          elevation: 0.0,
          leading: InkWell(
              onTap: () {
                notifyRepo.NotificationRepository()
                    .markAllNotificationsAsSeen();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => sosPage()));
              },
              child: Icon(Icons.arrow_back, color: Mycolors.textcolor)),
          title: Text("Notifications",
              style: TextStyle(color: Mycolors.textcolor)),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          )),
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
