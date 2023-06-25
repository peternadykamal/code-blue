import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradproject/style.dart';
import 'package:gradproject/translations/locale_keys.g.dart';

void noInternetToast() {
  Fluttertoast.showToast(
      msg: LocaleKeys.nointernet.tr(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Mycolors.buttonsos,
      textColor: Mycolors.fillingcolor,
      fontSize: 16.0);
}
