import 'package:flutter/material.dart';
import 'package:gradproject/repository/relation_repository.dart';
import 'package:gradproject/repository/user_repository.dart';
import 'package:gradproject/style.dart';

class CareGiversList extends StatefulWidget {
  @override
  _CareGiversListState createState() => _CareGiversListState();
}

class _CareGiversListState extends State<CareGiversList> {
  List<UserProfile> _careGivers = [];
  List<String> _relations = [];

  @override
  void initState() {
    super.initState();
    _getCareGivers();
  }

  Future<void> _getCareGivers() async {
    try {
      final Map<String, dynamic> result =
          await UserRepository().getCareGivers();
      setState(() {
        _careGivers = result['careGivers'];
        _relations = result['relations'];
      });
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _deleteRelation(int index) async {
    try {
      final relationId = _relations[index];
      await RelationRepository().deleteRelation(relationId);
      setState(() {
        _careGivers.removeAt(index);
        _relations.removeAt(index);
      });
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: _careGivers.length,
        itemBuilder: (context, index) {
          final careGiver = _careGivers[index];
          return Container(
            width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: careGiver.profileImage!.image,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 40.0, left: 10),
                  child: Text(careGiver.email,
                      style:
                          TextStyle(color: Mycolors.textcolor, fontSize: 17)),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteRelation(index),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
