import 'package:city_guide/utilities/widget_container/achievement_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../controller/attraction_controller.dart';
import 'attraction_screen.dart';

class AddAttractionScreen extends StatefulWidget {
  const AddAttractionScreen({super.key});

  @override
  State<AddAttractionScreen> createState() => _AddAttractionScreenState();
}

class _AddAttractionScreenState extends State<AddAttractionScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _imgPathController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AttractionController attractionController = AttractionController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedCity;
  String? selectedCategory;
  bool isLoading = false;
  final List<String> cities = [];

  @override
  void initState() {
    super.initState();
    getCities();
  }

  void getCities() async {
    setState(() {
      isLoading = true;
    });

    try {
      final querySnapshot =
      await FirebaseFirestore.instance.collection('cities').get();

      setState(() {
        cities.addAll(querySnapshot.docs.map((doc) => doc["city"] as String));
      });
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load cities: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Attractions'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade600],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, vertical: screenHeight * 0.05),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Add a New Attraction',
                  style: TextStyle(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02), // Responsive spacing

                // Form container with padding and shadow effect
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 12,
                  shadowColor: Colors.black.withOpacity(0.3),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Attraction Name Input
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Attraction Name',
                              labelStyle: const TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              prefixIcon: const Icon(Icons.location_on,
                                  color: Colors.blueAccent),
                              filled: true,
                              fillColor: Colors.blue.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the attraction name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          TextFormField(
                            controller: _imgPathController,
                            decoration: InputDecoration(
                              labelText: 'Image Path',
                              labelStyle: const TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              prefixIcon: const Icon(Icons.image,
                                  color: Colors.blueAccent),
                              filled: true,
                              fillColor: Colors.blue.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please provide an image path';
                              }
                              return null;
                            },
                          ),
                          // Responsive spacing
                          SizedBox(height: screenHeight * 0.02),
                          // Responsive spacing

                          // Description Input
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              labelStyle: const TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              prefixIcon: const Icon(Icons.description,
                                  color: Colors.blueAccent),
                              filled: true,
                              fillColor: Colors.blue.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please provide a description';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight * 0.02),


                          // Responsive spacing

                          // City Dropdown Input
                          isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : DropdownButtonFormField<String>(
                            value: selectedCity,
                            items: cities
                                .map((city) =>
                                DropdownMenuItem<String>(
                                  value: city,
                                  child: Text(city),
                                ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCity = value;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Select City',
                              labelStyle: const TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              filled: true,
                              fillColor: Colors.blue.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a city';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          DropdownButtonFormField<String>(
                            value: selectedCategory,
                            items: ['Event', 'Hotel', 'Restaurant']
                                .map((category) => DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Select Category',
                              labelStyle: const TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              filled: true,
                              fillColor: Colors.blue.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a category';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          SizedBox(width: 16),
                          TextFormField(
                            controller: _locationController,
                            decoration:  InputDecoration(
                              labelText: 'location Path',
                              labelStyle: const TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              filled: true,
                              fillColor: Colors.blue.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter latitude';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight * 0.02),

// Conditionally show date and time pickers
                          if (selectedCategory == 'Event')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                selectedDate == null
                                    ? TextButton(
                                  onPressed: () async {
                                    await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1999),
                                      lastDate: DateTime(2030),
                                      initialDate: DateTime.now(),
                                    ).then((value) {
                                      setState(() {
                                        selectedDate = value;
                                      });
                                      return null;
                                    });
                                  },
                                  child: const Text(
                                    "Start Date",
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                                    : Text(
                                    "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
                                selectedTime == null
                                    ? TextButton(
                                  onPressed: () async {
                                    await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      setState(() {
                                        selectedTime = value;
                                      });
                                    });
                                  },
                                  child: const Text(
                                    "Start Time",
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                                    : Text("${selectedTime!.hour}:${selectedTime!.minute}"),
                              ],
                            ),

                          SizedBox(height: screenHeight * 0.03),
                          // Responsive spacing

                          // Submit Button with gradient effect
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  // If validation passes, add the attraction
                                  attractionController.addAttraction(
                                    _nameController.text,
                                    _imgPathController.text,
                                    _descriptionController.text,
                                    selectedTime.toString(),
                                    selectedCategory.toString(),
                                    selectedDate.toString(),
                                    selectedCity.toString(),
                                    _locationController.text,
                                    context,
                                  );
                                  Navigator.pop(context, MaterialPageRoute(builder: (context) => AttractionScreen(),));
                                } else {
                                  showAchievementView(context, message: 'Please fill in all fields', title: 'Alert', icon:Icons.crisis_alert);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.1,
                                  vertical: screenHeight * 0.02,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.bold,
                                ),
                                shadowColor: Colors.blueAccent.withOpacity(0.3),
                                elevation: 8,
                              ),
                              child: const Text(
                                "Save Attraction",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),

                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
