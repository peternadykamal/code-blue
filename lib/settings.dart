import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:gradproject/auth.dart';
import 'package:gradproject/button2.dart';
import 'package:gradproject/main.dart';
import 'package:gradproject/profile1.dart';
import 'package:gradproject/repository/user_repository.dart';
import 'package:gradproject/services/auth_service.dart';
import 'package:gradproject/services/settings_service.dart';
import 'package:gradproject/splashscreen.dart';
import 'package:gradproject/style.dart';
import 'package:gradproject/utils/has_network.dart';
import 'package:gradproject/utils/no_inernet_toast.dart';

class settingsPage extends StatefulWidget {
  const settingsPage({super.key});

  @override
  State<settingsPage> createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {
  bool _switchValue = false;
  List<String> _phoneNumbers = [];
  String selectedLang = langCode;

  @override
  void initState() {
    super.initState();
    asyncFunction();
  }

  void asyncFunction() async {
    List<String> _fetchPhoneNumbers =
        await SettingsService.getNonCaregiversPhoneNumbers();
    bool _fetchSendSms = await SettingsService.getSendSms();
    setState(() {
      _switchValue = _fetchSendSms;
      _phoneNumbers = _fetchPhoneNumbers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Mycolors.fillingcolor,
        appBar: AppBar(
          backgroundColor: Mycolors.splashback,
          leading: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              },
              child: Icon(Icons.arrow_back, color: Mycolors.textcolor)),
          title: Row(
            children: [
              Text(langCode == 'en' ? "Settings " : "الاعدادات",
                  style: TextStyle(color: Mycolors.textcolor))
            ],
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          )),
        ),
        body: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Icon(Icons.person, color: Mycolors.buttonsos),
                Text(langCode == 'en' ? "Account" : "حساب",
                    style: TextStyle(color: Mycolors.buttonsos, fontSize: 20))
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(
                color: Mycolors.numpad,
                thickness: 1.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  if (await isNetworkAvailable() == false) {
                    noInternetToast();
                    return;
                  }
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('You will be signed out.'),
                        content: Text(
                            'Please check your email to reset your password.'),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Confirm'),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await AuthService().resetPassword();
                              await AuthService().signOut();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyApp()));
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        langCode == 'en'
                            ? "Change Password"
                            : "تغيير كلمة المرور",
                        style: TextStyle(
                            color: Mycolors.notpressed, fontSize: 16)),
                    Icon(Icons.chevron_right_sharp, color: Mycolors.notpressed)
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  if (await isNetworkAvailable() == false) {
                    noInternetToast();
                    return;
                  }
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Delete Account'),
                        content: Text(
                            'Are you sure you want to delete your account? This action cannot be undone.'),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Delete',
                                style: TextStyle(
                                    color: Mycolors.xbutton, fontSize: 16)),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => authPage(),
                                ),
                              );
                              await withInternetConnection(
                                  [UserRepository().deleteUserAccount]);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(langCode == 'en' ? "Delete Account" : "امسح الحساب",
                        style:
                            TextStyle(color: Mycolors.xbutton, fontSize: 16)),
                    Icon(Icons.chevron_right_sharp, color: Mycolors.xbutton)
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Icon(Icons.sms, color: Mycolors.buttonsos),
                Text(langCode == 'en' ? "SMS" : "الرسائل",
                    style: TextStyle(color: Mycolors.buttonsos, fontSize: 20))
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(
                color: Mycolors.numpad,
                thickness: 1.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      langCode == 'en'
                          ? "Allow Emergency SMS Messaging"
                          : "السماح بالرسائل القصيرة في حالات الطوارئ",
                      style:
                          TextStyle(color: Mycolors.notpressed, fontSize: 16)),
                  Switch(
                    // thumb color (round icon)
                    activeColor: Mycolors.buttonsos,
                    activeTrackColor: Mycolors.numpad,
                    inactiveThumbColor: Mycolors.fillingcolor,
                    inactiveTrackColor: Mycolors.numpad,
                    splashRadius: 50.0,
                    // boolean variable value
                    value: _switchValue,
                    // changes the state of the switch
                    onChanged: (value) async {
                      _switchValue = value;
                      await SettingsService.setSendSms(value);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            MediaQuery(
              data: MediaQueryData(),
              child: Container(
                decoration: BoxDecoration(
                  color: Mycolors.chatInput,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: MediaQuery.of(context).size.width - 40,
                height: MediaQuery.of(context).size.height - 450,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height - 540,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _phoneNumbers.length,
                          itemBuilder: (context, index) {
                            final phoneNumber = _phoneNumbers[index];
                            return Container(
                              padding: EdgeInsets.only(left: 10),
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 4, top: 4),
                              decoration: BoxDecoration(
                                  color: Mycolors.numpad,
                                  borderRadius: BorderRadius.circular(10)),
                              width: 200,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 40.0, left: 10),
                                    child: Text(
                                      phoneNumber,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Mycolors.textcolor,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.remove_circle),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Text(langCode == 'en'
                                                  ? "Are you sure you want to remove this number?"
                                                  : "هل انت متأكد انك تريد ازالة هذا الرقم؟"),
                                              actions: [
                                                TextButton(
                                                  child: Text(
                                                      langCode == 'en'
                                                          ? "Cancel"
                                                          : "الغاء",
                                                      style: TextStyle(
                                                          color: Mycolors
                                                              .textcolor)),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Mycolors
                                                                  .buttoncolor)),
                                                  child: Text(langCode == 'en'
                                                      ? "Remove"
                                                      : "ازالة"),
                                                  onPressed: () async {
                                                    await SettingsService
                                                        .removeNonCaregiversPhoneNumbers(
                                                            phoneNumber);
                                                    Navigator.of(context).pop();
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              settingsPage()),
                                                    );
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Button2(
                          textButton: langCode == 'en'
                              ? "Add Phone Numbers Of Non-app Caregivers"
                              : "اضافة ارقام مقدمي الرعاية الغير مشتركين",
                          onTap: () async {
                            try {
                              final PhoneContact contact =
                                  await FlutterContactPicker.pickPhoneContact();
                              String addThisNumber = contact
                                  .phoneNumber!.number!
                                  .replaceAll(RegExp(r'\s+\b|\b\s'), '')
                                  .replaceAll('-', '');
                              await SettingsService
                                  .addNonCaregiversPhoneNumbers(addThisNumber);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        settingsPage()),
                              );
                            } catch (UserCancelledPickingException) {
                              return;
                            }
                          },
                          width: 279,
                          height: 50),
                      SizedBox(height: 20)
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Icon(Icons.post_add, color: Mycolors.buttonsos),
                Text(langCode == 'en' ? "More" : "اكثر",
                    style: TextStyle(color: Mycolors.buttonsos, fontSize: 20))
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(
                color: Mycolors.numpad,
                thickness: 1.0,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: langCode == 'en'
                      ? const EdgeInsets.only(right: 97.0)
                      : const EdgeInsets.only(left: 97.0),
                  child: Text(langCode == 'en' ? "language" : "اللغة",
                      style:
                          TextStyle(color: Mycolors.textcolor, fontSize: 15)),
                ),
                FlutterToggleTab(
                  width: 40,
                  borderRadius: 15,
                  selectedBackgroundColors: [Mycolors.buttoncolor],
                  unSelectedBackgroundColors: [Mycolors.numpad],
                  selectedTextStyle: TextStyle(
                      color: Mycolors.fillingcolor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  unSelectedTextStyle: TextStyle(
                      color: Mycolors.textcolor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                  labels: langCode == 'en'
                      ? ["English", "Arabic"]
                      : ["انجليزي", "عربي"],
                  selectedIndex: selectedLang == 'en' ? 0 : 1,
                  selectedLabelIndex: (index) async {
                    if (index == 0) {
                      selectedLang = 'en';
                      await SettingsService.setLanguage('en');
                    } else {
                      selectedLang = 'ar';
                      await SettingsService.setLanguage('ar');
                    }
                    setState(() {});
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
