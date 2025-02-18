import 'package:city_guide/controller/attraction_controller.dart';
import 'package:city_guide/views/admin_panel/Admin_Attraction/add_attraction_screen.dart';
import 'package:city_guide/views/admin_panel/Admin_Attraction/edit_attraction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AttractionScreen extends StatelessWidget {
  AttractionScreen({super.key});
  final AttractionController attractionController = AttractionController();
  final Stream<QuerySnapshot> attractionForHotel =
  FirebaseFirestore.instance.collectionGroup('Hotel').snapshots();
  final Stream<QuerySnapshot> attractionForRestaurant =
  FirebaseFirestore.instance.collectionGroup('Restaurant').snapshots();
  final Stream<QuerySnapshot> attractionForEvent =
  FirebaseFirestore.instance.collectionGroup('Event').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attractions'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddAttractionScreen(),
                          ),
                        );
              },
              child: const Text(
                "Add",
                style: TextStyle(
                  // Text color
                  fontSize: 18.0, // Font size
                  fontWeight: FontWeight.bold,
                  color: Colors.white// Font weight
                ),
              ),
            ),
          ),

        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Attractions Management',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Hotels',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: StreamBuilder(
                  stream: attractionForHotel,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'No Hotels Found',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Something Went Wrong',
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final data = snapshot.data!.docs[index];
                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                              width: 180,
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'City: ${data['City']}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditAttractionScreen(
                                                    data: data,
                                                  ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () async {
                                          final String cityName = data['City']; // Replace with the actual city name
                                          const String category = 'Hotel'; // Replace with the actual category (e.g., Hotel, Restaurant)
                                          final String documentId = data.id; // Replace with the actual document ID

                                          try {
                                            // Validate input before calling the delete function
                                            if (category.isEmpty || documentId.isEmpty) {
                                              throw Exception('Invalid category or document ID');
                                            }

                                            // Call the delete function
                                            await attractionController.deleteAttractionById(
                                              cityName: cityName,
                                              category: category,
                                              documentId: documentId,
                                            );

                                            // Show success message
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text("Attraction deleted successfully")),
                                            );
                                          } catch (e) {
                                            // Show error message if something goes wrong
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text("Failed to delete attraction: $e")),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Restaurants',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: StreamBuilder(
                  stream: attractionForRestaurant,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'No Restaurants Found',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Something Went Wrong',
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final data = snapshot.data!.docs[index];
                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                              width: 180,
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'City: ${data['City']}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditAttractionScreen(
                                                    data: data,
                                                  ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () async {
                                          final String cityName = data['City']; // Replace with the actual city name
                                          const String category = 'Restaurant'; // Replace with the actual category (e.g., Hotel, Restaurant)
                                          final String documentId = data.id; // Replace with the actual document ID

                                          try {
                                            // Validate input before calling the delete function
                                            if (category.isEmpty || documentId.isEmpty) {
                                              throw Exception('Invalid category or document ID');
                                            }

                                            // Call the delete function
                                            await attractionController.deleteAttractionById(
                                              cityName: cityName,
                                              category: category,
                                              documentId: documentId,
                                            );

                                            // Show success message
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text("Attraction deleted successfully")),
                                            );
                                          } catch (e) {
                                            // Show error message if something goes wrong
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text("Failed to delete attraction: $e")),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Events',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: StreamBuilder(
                  stream: attractionForEvent,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'No Events Found',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Something Went Wrong',
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final data = snapshot.data!.docs[index];
                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                              width: 180,
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'City: ${data['City']}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditAttractionScreen(
                                                    data: data,
                                                  ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () async {
                                          final String cityName = data['City']; // Replace with the actual city name
                                          const String category = 'Event'; // Replace with the actual category (e.g., Hotel, Restaurant)
                                          final String documentId = data.id; // Replace with the actual document ID

                                          try {
                                            // Validate input before calling the delete function
                                            if (category.isEmpty || documentId.isEmpty) {
                                              throw Exception('Invalid category or document ID');
                                            }

                                            // Call the delete function
                                            await attractionController.deleteAttractionById(
                                              cityName: cityName,
                                              category: category,
                                              documentId: documentId,
                                            );

                                            // Show success message
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text("Attraction deleted successfully")),
                                            );
                                          } catch (e) {
                                            // Show error message if something goes wrong
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text("Failed to delete attraction: $e")),
                                            );
                                          }
                                        },
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
