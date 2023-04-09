import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradproject/button.dart';
import 'package:gradproject/button2.dart';
import 'package:gradproject/buttonselevated.dart';
import 'package:gradproject/profile2.dart';
import 'package:gradproject/style.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class profileone extends StatefulWidget {
  const profileone({super.key});

  @override
  State<profileone> createState() => _profileoneState();
}

class _profileoneState extends State<profileone> {
  bool selectMedical = true;
  bool selectCare = false;
  // ignore: unused_field
   File? image;
   final imagePicker=ImagePicker();

   uploadImage() async{
    var pickedImage= await imagePicker.getImage(source: ImageSource.camera);

    if(pickedImage!=null){
      setState(() {
        image=File(pickedImage.path);
      });


    }else{

    }

   }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      backgroundColor: Mycolors.splashback,
      body: Column(
    
        children: [Container(
          margin: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [InkWell(
              onTap: (){},
              child: Icon(
                Icons.close,
                size: 30,
                color: Mycolors.textcolor,
              
              ),
            ),
              Container(
                            margin: EdgeInsets.only(left: 30),
                          height:25 ,
                          width: 25,
                          
                          child: InkWell(
                            onTap: (){},
                            child: SvgPicture.asset("assets/images/Vector (2).svg")))],),
        ),


        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
            
            image==null? Image.asset("assets/images/Ellipse24.png",scale: 1.0) : CircleAvatar(
              radius: 40,
              backgroundImage: FileImage(image!)),


            GestureDetector(
              onTap: uploadImage,
              child: CircleAvatar(
                radius: 15,
                child: Icon(Icons.camera_alt_outlined,color: Mycolors.textcolor),
                backgroundColor: Colors.white,
              ),
            ),
        ],),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
            Text("<email address>",style: TextStyle(fontSize: 20,color: Mycolors.textcolor,fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.only(right:25.0),
              child: Text("<phone number>",style: TextStyle(fontSize: 15,color: Mycolors.notpressed,fontWeight: FontWeight.w700)),
              
            ),
          ],)
        ],) , 


        SizedBox(height: 20),
        
        Container(
          width: 300,
          height: 40,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Mycolors.buttoncolor),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
          Expanded(child:InkWell(
            onTap: () {
                 setState(() {
                              selectMedical = true;
                              selectCare = false;
                            });
            },
            child: elevButtons( text: "Medical Card", elevcolor:selectMedical? Colors.white:Mycolors.buttoncolor,bordercolor: selectMedical? Mycolors.textcolor:Mycolors.buttoncolor)),),
Expanded(child: InkWell(
  onTap: () {
       setState(() {
                              selectMedical = false;
                              selectCare = true;
                            });
  },
  child:   elevButtons(
  
                             text: "Care Givers", elevcolor: selectCare? Colors.white: Mycolors.buttoncolor,bordercolor:selectCare? Mycolors.textcolor :Mycolors.buttoncolor),
)),            
         ] ),
        ),
        SizedBox(height: 20),

                 (() {
if(selectMedical){
  return Card(
    elevation: 100,
    shape: CircleBorder(),
    borderOnForeground: false,
    child: Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),    color: Colors.white,),
      height: 420,
      width: 300,
  child: Column(children: [
    SizedBox(height: 20),
    Button2(textButton: "Fill Out Your Medical Info", onTap: (){
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> profile2()));
    }, width: 220, height: 60),
    
    SizedBox(height: 20),
    Padding(
      padding: const EdgeInsets.only(left:8.0),
      child: Text("In case of an emergency, paramedics will be able to quickly access vital information about your health, allergies, medications, and more, potentially saving your life.",style: TextStyle(color: Mycolors.notpressed,fontSize: 12,fontWeight: FontWeight.w600)),
    )
    ],
    
    ),
    ),
  );
}
return  Card(
    elevation: 100,
    shape: CircleBorder(),
    borderOnForeground: false,
    child: Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),    color: Colors.white,),
      height: 420,
      width: 300,
  
    ),
  );

                 } ())
        ],
        
        ),
      ),
      );
    
  }


}