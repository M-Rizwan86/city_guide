





import 'package:city_guide/utilities/widget_container/achievement_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CityController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  addCity(String cityname,String imagepath,String description , BuildContext context)async{
    try{
      await firestore.collection("cities").add({
        "city": cityname,
        "imagepath": imagepath,
        "description": description
      });
      showAchievementView(context,
          title: 'Success', message: 'City Has Been Added', icon:CupertinoIcons.smiley );
    }catch(e){
      showAchievementView(context,
          title: 'Error', message: 'An error occurred:$e',icon:Icons.cancel );
    }
  }
}