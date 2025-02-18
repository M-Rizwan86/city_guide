
import 'package:achievement_view/achievement_view.dart';
import 'package:flutter/material.dart';

void showAchievementView(BuildContext context,  {required String message ,required String title,required IconData icon  }){
  AchievementView(
      title: title,
      subTitle: message,
      //content: Widget()
      //onTab: _onTabAchievement,
      icon: Icon(icon),
      //typeAnimationContent: AnimationTypeAchievement.fadeSlideToUp,
      //borderRadius: 5.0,
      color: Colors.blue.shade100,
      //textStyleTitle: TextStyle(),
      //textStyleSubTitle: TextStyle(),
      //alignment: Alignment.topCenter,
      //duration: Duration(seconds: 3),
      //isCircle: false,
      listener: (status){
      }
  ).show(context);
}