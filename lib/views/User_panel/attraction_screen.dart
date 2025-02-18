import 'package:cached_network_image/cached_network_image.dart';
import 'package:city_guide/controller/attraction_controller.dart';
import 'package:city_guide/views/User_panel/attraction_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final AttractionController attractionController = AttractionController();

class CityDetailsScreen extends StatelessWidget {
  final String cityId;
  final String cityName;
  final String cityImage;
  final String cityDescription;

  const CityDetailsScreen({
    super.key,
    required this.cityId,
    required this.cityName,
    required this.cityImage,
    required this.cityDescription,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.height;
    final attractionsDataForEvent = FirebaseFirestore.instance
        .collection('attraction')
        .doc(cityName)
        .collection('Event');
    final attractionsDataForHotel = FirebaseFirestore.instance
        .collection('attraction')
        .doc(cityName)
        .collection('Hotel');
    final attractionsDataForRestaurant = FirebaseFirestore.instance
        .collection('attraction')
        .doc(cityName)
        .collection('Restaurant');

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // City Image and Name
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: CachedNetworkImage(
                imageUrl: cityImage,
                height: 410,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            ExpansionTile(
              leading: const Icon(
                Icons.maps_home_work,
                color: Colors.blue, // Color for the icon
              ),
              title: Text(
                cityName,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.lightBlueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'About the City:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        cityDescription,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: attractionsDataForEvent.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const SizedBox(
                      height: 100,
                      child: Center(
                          child: Text(
                        'There is not Events.',
                      )));
                }

                final attractionsForEvent = snapshot.data!.docs;

                return Column(
                  children: [
                    SizedBox(
                        height: 50,
                        width: screenWidth * 0.9,
                        child: const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                'Events',
                                style: TextStyle(fontSize: 30),
                              ),
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

                    // First ListView.builder
                    SizedBox(
                      height: screenHeight * 0.22,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: attractionsForEvent.length,
                        itemBuilder: (context, index) {
                          final attraction = attractionsForEvent[index].data()
                              as Map<String, dynamic>;
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
                                              description:
                                                  attraction['description'],
                                              imageUrl: attraction['imagepath'],
                                              time: attraction['time'],
                                              location: attraction['location'],
                                              category: attraction['category'],
                                              date: attraction['date']),
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
                                          attraction['category'],
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
            StreamBuilder<QuerySnapshot>(
              stream: attractionsDataForRestaurant.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const SizedBox(
                      height: 100,
                      child: Center(child: Text('No Restaurant found.')));
                }

                final attractionsForRestaurant = snapshot.data!.docs;

                return Column(
                  children: [
                    // First ListView.builder
                    SizedBox(
                        height: 50,
                        width: screenWidth * 0.9,
                        child: const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                'Restaurant',
                                style: TextStyle(fontSize: 30),
                              ),
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

                    SizedBox(
                      height: screenHeight * 0.22,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: attractionsForRestaurant.length,
                        itemBuilder: (context, index) {
                          final attractionRestaurant =
                              attractionsForRestaurant[index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AttractionDetailScreen(
                                              name:
                                                  attractionRestaurant['name'],
                                              description: attractionRestaurant[
                                                  'description'],
                                              imageUrl: attractionRestaurant[
                                                  'imagepath'],
                                              time:
                                                  attractionRestaurant['time'],
                                              location: attractionRestaurant[
                                                  'location'],
                                              category: attractionRestaurant[
                                                  'category'],
                                              date:
                                                  attractionRestaurant['date']),
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
                                            attractionRestaurant['imagepath'],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          attractionRestaurant['category'],
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
            StreamBuilder<QuerySnapshot>(
              stream: attractionsDataForHotel.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const SizedBox(
                      height: 100,
                      child: Center(child: Text('No Hotels found.')));
                }

                final attractionsForHotel = snapshot.data!.docs;

                return Column(
                  children: [
                    SizedBox(
                        height: 50,
                        width: screenWidth * 0.9,
                        child: const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                'Hotels',
                                style: TextStyle(fontSize: 30),
                              ),
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

                    // First ListView.builder
                    SizedBox(
                      height: screenHeight * 0.22,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: attractionsForHotel.length,
                        itemBuilder: (context, index) {
                          final attractionHotel = attractionsForHotel[index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AttractionDetailScreen(
                                              name: attractionHotel['name'],
                                              description: attractionHotel[
                                                  'description'],
                                              imageUrl:
                                                  attractionHotel['imagepath'],
                                              time: attractionHotel['time'],
                                              location:
                                                  attractionHotel['location'],
                                              category:
                                                  attractionHotel['category'],
                                              date: attractionHotel['date']),
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
                                            attractionHotel['imagepath'],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          attractionHotel['category'],
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
          ],
        ),
      ),
    );
  }
}
