import 'package:cached_network_image/cached_network_image.dart';
import 'package:city_guide/controller/auth_controller.dart';
import 'package:city_guide/utilities/widget_container/app_drawer.dart';
import 'package:city_guide/views/User_panel/attraction_detail_screen.dart';
import 'package:city_guide/views/User_panel/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'attraction_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final AppBarDrawer drawer = const AppBarDrawer();

  final User? user = FirebaseAuth.instance.currentUser;
  final userData = FirebaseFirestore.instance.collection('Users');
  final cityData = FirebaseFirestore.instance.collection('cities');
  final attractionsDataForEvent =
      FirebaseFirestore.instance.collectionGroup('Event');
  final attractionsDataForResturant =
      FirebaseFirestore.instance.collectionGroup('Restaurant');
  final attractionsDataForHotel =
      FirebaseFirestore.instance.collectionGroup('Hotel');

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('City Guide'),
        centerTitle: true,
      ),
      drawer: drawer,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade600,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<DocumentSnapshot>(
                        future:
                            user != null ? userData.doc(user!.uid).get() : null,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data == null ||
                              user == null) {
                            return Row(
                              children: [

                                SizedBox(width: screenWidth * 0.05),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Guest",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                  ],
                                ),
                                const Spacer(),
                                const Icon(Icons.notifications,
                                    color: Colors.white, size: 28),
                              ],
                            );
                          } else {
                            Map<String, dynamic> useraccData = snapshot.data!
                                    .data() as Map<String, dynamic>? ??
                                {};
                            return Row(
                              children: [
                                SizedBox(width: screenWidth * 0.04),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      useraccData["username"] ?? "Unknown User",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      'Good morning',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white70),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                const Icon(Icons.notifications,
                                    color: Colors.white, size: 28),
                              ],
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context) => SearchScreen(),));
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white, // Matches the filled color
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(Icons.search, color: Colors.grey),
                              ),
                              Expanded(
                                child: Text(
                                  'Search here...',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        )

                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.1,
              width: screenWidth * 0.9,
              child: const Padding(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lets Explore',
                      style: TextStyle(fontSize: 30),
                    ),
                    Icon(
                      Icons.arrow_downward,
                      size: 30,
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: StreamBuilder(
                stream: cityData.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No cities available'));
                  }

                  return SizedBox(
                    height: screenHeight * 0.45,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final data = snapshot.data!.docs[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CityDetailsScreen(
                                    cityId: data.id,
                                    cityName: data['city'],
                                    cityImage: data['imagepath'],
                                    cityDescription: data['description']),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Stack(
                              children: [
                                Opacity(
                                  opacity: 0.9,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: data['imagepath'],
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      height: double.infinity,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 10,
                                  child: Text(
                                    data['city'] ?? 'Unknown City',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.lightBlueAccent,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black,
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(
                height: 50,
                width: screenWidth * 0.9,
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Events',
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 30,
                      )
                    ],
                  ),
                )),
            StreamBuilder<QuerySnapshot>(
              stream: attractionsDataForEvent.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No Events found.'));
                }

                final attractionsForEvent = snapshot.data!.docs;

                return Column(
                  children: [
                    // First ListView.builder
                    SizedBox(
                      height: screenHeight * 0.22,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: attractionsForEvent.length,
                        itemBuilder: (context, index) {
                          final attraction = attractionsForEvent[index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AttractionDetailScreen(
                                        name: attraction['name'],
                                        description: attraction['description'],
                                        imageUrl: attraction['imagepath'],
                                        location: attraction['location'],
                                        category: attraction['category'],
                                        time: attraction['time'],
                                        date: attraction['date'],
                                      ),
                                    ));
                              },
                              child: Card(
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Container(
                                  width: 140,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.blue.shade600,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.network(
                                            attraction['imagepath'],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          attraction['City'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Second ListView.builder
                  ],
                );
              },
            ),
            SizedBox(
                height: 50,
                width: screenWidth * 0.9,
                child: const Row(
                  children: [
                    Text(
                      'Restaurant',
                      style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 35,
                    )
                  ],
                )),
            StreamBuilder<QuerySnapshot>(
              stream: attractionsDataForResturant.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No Restaurant found.'));
                }

                final attractionsForResturant = snapshot.data!.docs;

                return Column(
                  children: [

                    // First ListView.builder
                    SizedBox(
                      height: screenHeight * 0.22,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: attractionsForResturant.length,
                        itemBuilder: (context, index) {
                          final attraction = attractionsForResturant[index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AttractionDetailScreen(
                                        name: attraction['name'],
                                        description: attraction['description'],
                                        imageUrl: attraction['imagepath'],
                                        location: attraction['location'],
                                        category: attraction['category'],
                                        time: attraction['time'],
                                        date: attraction['date'],
                                      ),
                                    ));
                              },
                              child: Card(
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Container(
                                  width: 140,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.blue.shade600,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.network(
                                            attraction['imagepath'],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          attraction['City'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Second ListView.builder
                  ],
                );
              },
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
                height: 50,
                width: screenWidth * 0.9,
                child: const Row(
                  children: [
                    Text(
                      'Hotels',
                      style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 35,
                    )
                  ],
                )),
            StreamBuilder<QuerySnapshot>(
              stream: attractionsDataForHotel.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No Hotels found.'));
                }

                final attractionsForHotel = snapshot.data!.docs;

                return Column(
                  children: [
                    // First ListView.builder
                    SizedBox(
                      height: screenHeight * 0.22,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: attractionsForHotel.length,
                        itemBuilder: (context, index) {
                          final attraction = attractionsForHotel[index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Card(
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AttractionDetailScreen(
                                          name: attraction['name'],
                                          description:
                                              attraction['description'],
                                          imageUrl: attraction['imagepath'],
                                          location: attraction['location'],
                                          category: attraction['category'],
                                          time: attraction['time'],
                                          date: attraction['date'],
                                        ),
                                      ));
                                },
                                child: Container(
                                  width: 140,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.blue.shade600,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.network(
                                            attraction['imagepath'],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          attraction['City'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Second ListView.builder
                  ],
                );
              },
            ),
            SizedBox(
              height: screenHeight * 0.2,
            )
          ],
        ),
      ),
    );
  }
}
