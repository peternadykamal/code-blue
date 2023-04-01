import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum Gender { male, female }

enum BloodType { a, b, ab, o }

enum RhBloodType { positive, pegative }

// here is an example on how to create a user profile:
// UserProfile user = UserProfile(
//   email: 'nady.peter@gmail.com',
//   weight: 70.0,
//   height: 170.0,
//   bloodType: BloodType.a,
//   rhBloodType: RhBloodType.positive,
//   medicalCondition: 'Diabetes',
//   medications: 'Insulin',
//   allergies: 'Pollen',
//   remarks: 'None',
// );

class UserProfile {
  String email;
  DateTime? birthDate;
  int? age;
  Gender? gender;
  double? weight;
  double? height;
  BloodType? bloodType;
  RhBloodType? rhBloodType;
  String? medicalCondition;
  String? medications;
  String? allergies;
  String? remarks;
  // String profileImageUrl;

  UserProfile({
    required this.email,
    this.birthDate,
    this.age,
    this.gender,
    this.weight,
    this.height,
    this.bloodType,
    this.rhBloodType,
    this.medicalCondition,
    this.medications,
    this.allergies,
    this.remarks,
  });

  static UserProfile fromDataSnapshotList(Iterable<DataSnapshot> map) {
    var email = '';
    DateTime? birthDate;
    int? age;
    Gender? gender;
    double? weight;
    double? height;
    BloodType? bloodType;
    RhBloodType? rhBloodType;
    String? medicalCondition;
    String? medications;
    String? allergies;
    String? remarks;

    for (var snapshot in map) {
      switch (snapshot.key) {
        case 'email':
          email = snapshot.value.toString();
          break;
        case 'birthDate':
          birthDate = DateTime.tryParse(snapshot.value.toString());
          if (birthDate != null) {
            var now = DateTime.now();
            age = now.year - birthDate.year;
            if (now.month < birthDate.month ||
                (now.month == birthDate.month && now.day < birthDate.day)) {
              age--;
            }
          }
          break;
        case 'gender':
          gender = Gender.values[snapshot.value as int];
          break;
        case 'weight':
          weight = double.tryParse(snapshot.value.toString());
          break;
        case 'height':
          height = double.tryParse(snapshot.value.toString());
          break;
        case 'bloodType':
          bloodType = BloodType.values[snapshot.value as int];
          break;
        case 'rhBloodType':
          rhBloodType = RhBloodType.values[snapshot.value as int];
          break;
        case 'medicalCondition':
          medicalCondition = snapshot.value.toString();
          break;
        case 'medications':
          medications = snapshot.value.toString();
          break;
        case 'allergies':
          allergies = snapshot.value.toString();
          break;
        case 'remarks':
          remarks = snapshot.value.toString();
          break;
        default:
          break;
      }
    }

    return UserProfile(
      email: email,
      birthDate: birthDate,
      age: age,
      gender: gender,
      weight: weight,
      height: height,
      bloodType: bloodType,
      rhBloodType: rhBloodType,
      medicalCondition: medicalCondition,
      medications: medications,
      allergies: allergies,
      remarks: remarks,
    );
  }
}

class UserRepository {
  final DatabaseReference _usersRef =
      FirebaseDatabase.instance.ref().child('users');
  User user = FirebaseAuth.instance.currentUser!;

  /// Example on how to use this method without async/await:
  /// ```dart
  /// UserRepository()
  ///     .updateUserProfile(userProfile)
  ///     .then((value) => {print("user profile updated")});
  /// ```
  /// example on how to use this method with async/await:
  /// ```dart
  /// await UserRepository().updateUserProfile(userProfile);
  /// ```
  Future<void> updateUserProfile(UserProfile data) async {
    Map<String, dynamic> updateData = {
      'email': data.email,
    };

    if (data.gender != null) {
      updateData['gender'] = data.gender?.index;
    }
    if (data.weight != null) {
      updateData['weight'] = data.weight;
    }
    if (data.height != null) {
      updateData['height'] = data.height;
    }
    if (data.bloodType != null) {
      updateData['bloodType'] = data.bloodType?.index;
    }
    if (data.rhBloodType != null) {
      updateData['rhBloodType'] = data.rhBloodType?.index;
    }
    if (data.medications != null) {
      updateData['medications'] = data.medications;
    }
    if (data.allergies != null) {
      updateData['allergies'] = data.allergies;
    }
    if (data.remarks != null) {
      updateData['remarks'] = data.remarks;
    }
    if (data.medicalCondition != null) {
      updateData['medicalCondition'] = data.medicalCondition;
    }
    if (data.birthDate != null) {
      updateData['birthDate'] = data.birthDate.toString();
    }
    try {
      await _usersRef.child(user.uid).update(updateData);
    } catch (e) {
      throw Exception("Error updating user profile: $e");
    }
  }

  /// Example on how to use this method without async/await:
  /// ```dart
  /// UserRepository().getUserProfile().then((user) {
  ///   print(user.email);
  ///   print(user.age);
  /// });
  /// ```
  /// example on how to use this method with async/await:
  /// ```dart
  /// UserProfile user = await UserRepository().getUserProfile();
  /// ```
  Future<UserProfile> getUserProfile() async {
    try {
      final snapshot = await _usersRef.child(user.uid).get();
      if (snapshot.exists) {
        final data = snapshot.children;
        return UserProfile.fromDataSnapshotList(data);
      } else {
        throw Exception('User does not exist');
      }
    } catch (e) {
      throw Exception("Error getting user profile: $e");
    }
  }

  /// example on how to use this method without async/await:
  /// ```dart
  /// UserRepository().deleteUserAccount().then((value) => {print("user deleted")});
  ///  ```
  /// example on how to use this method with async/await:
  /// ```dart
  /// await UserRepository().deleteUserAccount();
  /// ```
  Future<void> deleteUserAccount() async {
    try {
      _usersRef.child(user.uid).remove();
    } catch (e) {
      throw Exception("Error deleting user account: $e");
    }
  }

  /// example on how to use this method without async/await:
  /// ```dart
  /// UserRepository().fuzzyUserEmailSearch("emailQuery").then((userIds) {
  ///  print(userIds);
  ///   });
  /// ```
  /// example on how to use this method with async/await:
  /// ```dart
  /// List<String> userIds = await UserRepository().fuzzyUserEmailSearch("emailQuery");
  /// ```
  /// [getIDsList] is a boolean that determines if the method will return a list of user IDs or a list of user emails
  Future<List<String>> fuzzyUserEmailSearch(String emailQuery,
      {bool getIDsList = false}) async {
    Query query = _usersRef
        .orderByChild('email')
        .startAt(emailQuery)
        .endAt("$emailQuery\uF7FF");
    final snapshot = await query.get();

    List<String> userIds = [];
    if (snapshot.value != null) {
      print(snapshot.value);
      for (final users in snapshot.children) {
        if (getIDsList) {
          userIds.add(users.key.toString());
        } else {
          userIds.add(users.child('email').value.toString());
        }
        print(users.key);
      }
    }
    return userIds;
  }
}
