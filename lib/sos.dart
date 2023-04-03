import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradproject/profile1.dart';
import 'package:gradproject/style.dart';
import 'package:gradproject/translations/locale_keys.g.dart';

class sosPage extends StatefulWidget {
  const sosPage({super.key});

  @override
  State<sosPage> createState() => _sosPageState();
}

class _sosPageState extends State<sosPage> 
with SingleTickerProviderStateMixin {

bool notification=true;
  late final TabController controller;
   void initState() {
    controller = TabController(length: 2, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    


    return DefaultTabController(
      
      
          length: 3,
          child: SafeArea(
            child: Scaffold(
              body: TabBarView(
                children: [

                                    Center(
                    child: Text("2nd Screen"),
                  ),
                  Center(
                    child: Column(
            children: [
               
              SizedBox(height: 30),
              Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(children: [
                    Text(LocaleKeys.welcomeback.tr(),style: TextStyle(color: Mycolors.notpressed,fontSize: 20,fontWeight: FontWeight.bold)),
                    Text(LocaleKeys.username.tr(),style: TextStyle(color: Mycolors.textcolor,fontSize: 20,fontWeight: FontWeight.w700)),
                  ],),
                  SizedBox(width: 20),
          
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SvgPicture.asset(
                       notification==true ? ("assets/images/notification.svg"):("assets/images/no notification.svg")
                      ),
                      SizedBox(width: 10),
                      CircleAvatar(radius: 25,
                      child: InkWell(
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => profileone())));
                        },
                        child: SvgPicture.asset("assets/images/default profile picture.svg")),
                      ),
                    ],
                  ),
          
          
          
          
          
          
                ],
              ),
          SizedBox(height: 80),
          Center(child: Text(LocaleKeys.clickbuttonbelow.tr(),style: TextStyle(color: Mycolors.notpressed,fontSize: 24,fontWeight: FontWeight.normal))),
          Text(LocaleKeys.duringemerg.tr(),style: TextStyle(color: Mycolors.notpressed,fontSize: 24,fontWeight: FontWeight.normal)),
          SizedBox(height: 40),
          InkWell(
            onTap: (){},
            child:   CircleAvatar(
            
              radius: 140,
            
            child: Stack(children:[SvgPicture.asset("assets/images/sos button.svg")]),),
          ) ]),),
                  

                  Center(
                    child: Text("3rd Screen"),
                  ),
          
                ],
              ),
              bottomNavigationBar: Material(
                color: Mycolors.fillingcolor,
                child: TabBar(
                  indicatorColor:Mycolors.textcolor ,
                          
                  labelColor: Mycolors.textcolor,
                    tabs: [
                  Tab(child: Icon(Icons.chat,size: 30),),
                  Tab(child: Icon(Icons.home,size: 30),),
                  Tab(child: Icon(Icons.map,size: 30,),),
                     
                ]),
              ),
            ),
          ),
        );  
  }
}



        

        








    
