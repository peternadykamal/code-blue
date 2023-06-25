import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradproject/repository/invite_repository.dart';
import 'package:gradproject/repository/relation_repository.dart';
import 'package:gradproject/repository/user_repository.dart';
import 'package:gradproject/style.dart';
import 'package:gradproject/translations/locale_keys.g.dart';
import 'package:gradproject/utils/has_network.dart';
import 'package:paginated_search_bar/paginated_search_bar.dart';
import 'package:paginated_search_bar/paginated_search_bar_state_property.dart';
import 'package:flutter/material.dart';
import 'package:paginated_search_bar/paginated_search_bar.dart';
import 'package:endless/endless.dart';

class searchPage extends StatefulWidget {
  const searchPage({super.key});

  @override
  State<searchPage> createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  final TextEditingController _controller = TextEditingController();
  final EndlessPaginationController<UserProfile> _users =
      EndlessPaginationController<UserProfile>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: 80),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/backgroundtwo.png"),
                fit: BoxFit.fill)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Mycolors.fillingcolor,
              child: SizedBox(
                width: 600,
                child: Card(
                  elevation: 10,
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: PaginatedSearchBar<UserProfile>(
                        inputController: _controller,
                        listController: _users,
                        containerDecoration:
                            BoxDecoration(color: Mycolors.fillingcolor),
                        maxHeight: 300,
                        hintText: LocaleKeys.search.tr(),
                        emptyBuilder: (context) {
                          return Text(LocaleKeys.usernotfound.tr());
                        },
                        placeholderBuilder: (context) {
                          return Text(LocaleKeys.sendinvite.tr());
                        },
                        paginationDelegate: EndlessPaginationDelegate(
                          pageSize: 20,
                          maxPages: 3,
                        ),
                        minSearchLength: 0,
                        onSearch: ({
                          required pageIndex,
                          required pageSize,
                          required searchQuery,
                        }) async {
                          return Future.delayed(
                              const Duration(milliseconds: 1000), () async {
                            if (searchQuery == "empty") {
                              return [];
                            }
                            List<dynamic> results =
                                await withInternetConnection([
                              () async {
                                List<String> userIDs = await UserRepository()
                                    .fuzzyUserEmailSearch(searchQuery,
                                        getIDsList: true);
                                List<UserProfile> users = [];
                                for (String userID in userIDs) {
                                  users.add(await UserRepository()
                                      .getUserById(userID));
                                }
                                return users;
                              }
                            ]);
                            return results.length == 1
                                ? results[0] as List<UserProfile>
                                : [];
                          });
                        },
                        itemBuilder: (
                          context, {
                          required item,
                          required index,
                        }) {
                          return InkWell(
                            onTap: () async {
                              try {
                                String id = await UserRepository()
                                    .getUserIdByEmail(item.email);
                                _controller.clear();
                                _users.clear();
                                await InviteRepository().createInvitation(id);
                                Fluttertoast.showToast(
                                  msg: LocaleKeys.invitationsent.tr(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Mycolors.buttoncolor,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
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
                            child: Container(
                              width: 200,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: item.profileImage!.image,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 40.0),
                                    child: Text(item.email,
                                        style: TextStyle(
                                            color: Mycolors.textcolor,
                                            fontSize: 17)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
