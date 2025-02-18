import 'package:city_guide/controller/auth_controller.dart';
import 'package:city_guide/utilities/widget_container/app_drawer.dart';
import 'package:city_guide/views/admin_panel/Cities/cities_screen.dart';
import 'package:city_guide/views/admin_panel/user_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'Admin_Attraction/attraction_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final AppBarDrawer drawer = const AppBarDrawer();
  final User? user = FirebaseAuth.instance.currentUser;
  CollectionReference cities = FirebaseFirestore.instance.collection('cities');
  CollectionReference userData = FirebaseFirestore.instance.collection('Users');

  final userName = FirebaseFirestore.instance;
  int documentCount = 0;
  bool isLoading = true;
  int documentCountAttraction =0;
  int documentCountAttraction2 = 0;
  int documentCountAttraction3 = 0;
  int totalAttractions = 0;

  @override
  void initState() {
    super.initState();
    getDocumentCount();
    getDocumentCountAttractions();
  }



  Future<void> getDocumentCountAttractions() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collectionGroup('Event').get();
      QuerySnapshot snapshot2 = await FirebaseFirestore.instance.collectionGroup('Hotel').get();
      QuerySnapshot snapshot3 = await FirebaseFirestore.instance.collectionGroup('Resturant').get();
      documentCountAttraction = snapshot.docs.length;
      documentCountAttraction2 = snapshot2.docs.length;
      documentCountAttraction3 = snapshot3.docs.length;
      setState(() {

        totalAttractions = documentCountAttraction + documentCountAttraction2 + documentCountAttraction3;

        isLoading = false;

      });
    } catch (e) {
      if (kDebugMode) {
        print('Error getting document count: $e');
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getDocumentCount() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('cities').get();
      setState(() {
        documentCount = snapshot.docs.length;
        isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error getting document count: $e');
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  // Extract user details

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF007BFF),
        leadingWidth: screenWidth * 0.15, // Adjusted based on screen width
        title: Text(
          "City Guide",
          style: TextStyle(fontSize: screenWidth * 0.075), // Scaled font size
        ),
        centerTitle: true,

      ),
      drawer: drawer,

      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          color: Color(0xffF5F5F5),
        ),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.025), // Scaled padding
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(screenWidth * 0.02), // Scaled padding
                  child: Text(
                    "Dashboard",
                    style: TextStyle(
                      fontSize: screenWidth * 0.06, // Scaled font size
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column
                    Column(
                      children: [
                        // Add Attractions Card
                        Padding(
                          padding: EdgeInsets.only(bottom: screenHeight * 0.03), // Scaled padding
                          child:GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AttractionScreen(),
                                ),
                              );
                            },
                            child: Container(
                              height: screenHeight * 0.25,
                              width: screenWidth * 0.45,
                              decoration: BoxDecoration(
                                // Gradient background like in the "City" container
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF007BFF), Color(0xFF0066CC)], // Gradient from light blue to deep blue
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(15), // More rounded corners for a modern look
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 15,
                                    spreadRadius: 1,
                                    offset: const Offset(5, 5),
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.6),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                    offset: const Offset(-5, -5),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: screenHeight * 0.1, // Scaled position
                                    left: screenWidth * 0.2, // Scaled position
                                    child: Icon(
                                      Icons.add_box_outlined,
                                      size: screenWidth * 0.15, // Scaled icon size
                                      color: Colors.white,
                                    ),
                                  ),
                                  Positioned(
                                    top: screenHeight * 0.18, // Scaled position
                                    left: screenWidth * 0.2, // Scaled position
                                    child: Icon(
                                      Icons.delete,
                                      size: screenWidth * 0.15, // Scaled icon size
                                      color: Colors.white,
                                    ),
                                  ),
                                  Positioned(
                                    top: screenHeight * 0.02, // Scaled position
                                    left: screenWidth * 0.02, // Scaled position
                                    child: Text(
                                      "Attractions",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.075, // Scaled font size
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: screenHeight * 0.09, // Scaled position
                                    left: screenWidth * 0.05, // Scaled position
                                    child: Row(
                                      children: [
                                        Text(
                                    '$totalAttractions',// Replace with dynamic number if necessary
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.08, // Scaled font size
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ),
                        // User Reviews Card
                        Padding(
                          padding: EdgeInsets.only(bottom: screenHeight * 0.03), // Scaled padding
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UserScreen(),
                                ),
                              );
                            },
                            child: Container(
                              height: screenHeight * 0.5,
                              width: screenWidth * 0.45,
                              decoration: BoxDecoration(
                                // Gradient background for a more modern look
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF007BFF), Color(0xFF0066CC)], // Deep blue gradient
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(15),  // Slightly more rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 15,
                                    spreadRadius: 1,
                                    offset: const Offset(5, 5),
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.6),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                    offset: const Offset(-5, -5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(screenWidth * 0.03),  // Scaled padding
                                    child: Text(
                                      "User",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.06,  // Scaled font size for the title
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: StreamBuilder(
                                      stream: userName.collection('Users').snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return const Center(
                                            child: Text(
                                              "No Data Found",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          );
                                        }
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        return ListView.builder(
                                          itemCount: snapshot.data!.docs.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            final userDisplay = snapshot.data!.docs;
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: screenWidth * 0.03, // Scaled padding
                                              ),
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),  // Rounded corners for cards
                                                ),
                                                elevation: 5,
                                                margin: EdgeInsets.symmetric(
                                                  vertical: screenHeight * 0.02, // Scaled margin
                                                ),
                                                child: ListTile(
                                                  contentPadding: EdgeInsets.symmetric(
                                                    horizontal: screenWidth * 0.03,  // Scaled padding
                                                    vertical: screenHeight * 0.01,
                                                  ),
                                                  leading: CircleAvatar(
                                                    backgroundColor: Colors.white70,
                                                    child: Text(
                                                      "${index + 1}",
                                                      style: TextStyle(
                                                        fontSize: screenWidth * 0.045,  // Scaled font size for index
                                                      ),
                                                    ),
                                                  ),
                                                  title: Text(
                                                    '${userDisplay[index]['username']}',
                                                    style: TextStyle(
                                                      fontSize: screenWidth * 0.045,  // Scaled font size for username
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ),
                      ],
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    // Right Column
                    Column(
                      children: [
                        // User Reviews Card (newly added)
                        Padding(
                          padding: EdgeInsets.only(bottom: screenHeight * 0.03), // Scaled padding
                          child: Container(
                            height: screenHeight * 0.5,
                            width: screenWidth * 0.45,
                            decoration: BoxDecoration(
                              color: const Color(0xFF007BFF),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 15,
                                  spreadRadius: 1,
                                  offset: const Offset(5, 5),
                                ),
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.7),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                  offset: const Offset(-5, -5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(screenWidth * 0.02), // Scaled padding
                                  child: Text(
                                    "User Reviews",
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.05, // Scaled font size
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: StreamBuilder(
                                    stream: userName.collection('Users').snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Center(
                                          child: Text(
                                            "No Data Found",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        );
                                      }
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      return ListView.builder(
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          final userDisplay = snapshot.data!.docs;
                                          return ListTile(
                                            leading: Text(
                                              "${index + 1}",
                                              style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.white70),
                                            ),
                                            title: Text(
                                              '${userDisplay[index]['username']}',
                                              style: const TextStyle(color: Colors.white70),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Cities Crud
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CitiesScreen()),
                            );
                          },
                          child: Container(
                            height: screenHeight * 0.25,
                            width: screenWidth * 0.45,
                            decoration: BoxDecoration(
                              // Updated gradient background for a modern feel
                              gradient: const LinearGradient(
                                colors: [Color(0xFF2196F3), Color(0xFF03A9F4)],  // Light blue gradient
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(15),  // Slightly more rounded corners
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                  offset: const Offset(5, 5),
                                ),
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.6),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                  offset: const Offset(-5, -5),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                // Title Text
                                Padding(
                                  padding: EdgeInsets.all(screenWidth * 0.04),  // Scaled padding
                                  child: Text(
                                    "Cities",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenWidth * 0.085,  // Scaled font size
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                // Row to display document count and icon
                                Positioned(
                                  bottom: screenHeight * 0.05,  // Positioned at the bottom
                                  left: screenWidth * 0.04,  // Slight left padding for the text
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      isLoading
                                          ? const CircularProgressIndicator(
                                        color: Colors.white,  // White color for the loading indicator
                                      )
                                          : Text(
                                        '$documentCount',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.06,  // Scaled font size
                                          color: Colors.white,
                                        ),
                                      ),
                                      // Icon for location
                                      Padding(
                                        padding: const EdgeInsets.only(left: 32, top: 60),
                                        child: Icon(
                                          Icons.location_city,
                                          size: screenWidth * 0.22,  // Scaled icon size
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
