import 'package:city_guide/utilities/widget_container/achievement_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AttractionController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to get the current location

  Future<void> addAttraction(
    String attName,
    String attImage,
    String attDes,
    String attTiming,
    String attCategory,
    String attDate,
    String attCity,
    String attLocation,
    BuildContext context,
  ) async {
    try {
      // Get current location

      await _firestore
          .collection('attraction')
          .doc(attCity)
          .collection(attCategory)
          .add({
        'name': attName,
        'imagepath': attImage,
        'description': attDes,
        'time': attTiming,
        'category': attCategory,
        'date': attDate,
        'City': attCity,
        'location': attLocation, // Add latitude
      });
      showAchievementView(context,
          title: 'Success',
          message: 'Attraction has been added',
          icon: CupertinoIcons.smiley);
    } catch (e) {
      showAchievementView(context,
          title: 'Error', message: 'An error occurred: $e', icon: Icons.cancel);
    }
  }

  Future<void> updateAttraction(
    String id,
    String attName,
    String attDes,
    String attTiming,
    String attCategory,
    String attLocation,
    String attDate,
    String attCity,
    String attImage,
    BuildContext context,
  ) async {
    try {
      // Get current location

      await _firestore
          .collection('attraction')
          .doc(attCity)
          .collection(attCategory)
          .doc(id)
          .set({
        'name': attName,
        'description': attDes,
        'time': attTiming,
        'category': attCategory,
        'location': attLocation, // Update longitude
        'date': attDate,
        'City': attCity,
        'imagepath': attImage,
      }, SetOptions(merge: true));
      showAchievementView(context,
          message: 'Data Updated Successfully', title: "", icon: Icons.check);
    } catch (e) {
      showAchievementView(context,
          message: 'An error occurred while updating: $e',
          title: "Error",
          icon: Icons.cancel);
    }
  }

  Future<void> deleteAttractionById({
    required String cityName,
    required String category,
    required String documentId,
  }) async {
    try {
      await _firestore
          .collection('attraction')
          .doc(cityName)
          .collection(category)
          .doc(documentId)
          .delete();
    } catch (e) {
      throw Exception("Failed to delete attraction");
    }
  }
}
