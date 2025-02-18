import 'package:flutter/material.dart';
import 'package:city_guide/controller/city_controller.dart';
import 'package:city_guide/utilities/widget_container/form_widget.dart';

class AddCities extends StatefulWidget {
  const AddCities({super.key});

  @override
  State<AddCities> createState() => _AddCitiesState();
}

class _AddCitiesState extends State<AddCities> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController imgPathController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form validation key

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    imgPathController.dispose();
    descController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CityController controller = CityController();

    // Get screen dimensions using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add City'),
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
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.05), // Adjust padding based on screen size
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title for the page
                Text(
                  'Add a New City',
                  style: TextStyle(
                    fontSize: screenWidth * 0.07, // Responsive font size
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
                    padding: EdgeInsets.all(screenWidth * 0.05), // Adjust padding based on screen size
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // City Name Input
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'City Name',
                              labelStyle: const TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              prefixIcon: const Icon(Icons.location_city, color: Colors.blueAccent),
                              filled: true,
                              fillColor: Colors.blue.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the city name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight * 0.02), // Responsive spacing

                          // Image Path Input
                          TextFormField(
                            controller: imgPathController,
                            decoration: InputDecoration(
                              labelText: 'Image Path',
                              labelStyle: const TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              prefixIcon: const Icon(Icons.image, color: Colors.blueAccent),
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
                          SizedBox(height: screenHeight * 0.02), // Responsive spacing

                          // Description Input
                          TextFormField(
                            controller: descController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              labelStyle: const TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              prefixIcon: const Icon(Icons.description, color: Colors.blueAccent),
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
                          SizedBox(height: screenHeight * 0.03), // Responsive spacing

                          // Submit Button with gradient effect
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  controller.addCity(
                                    nameController.text,
                                    imgPathController.text,
                                    descController.text,
                                    context,
                                  );
                                  Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.1, // Adjust button padding
                                  vertical: screenHeight * 0.02, // Adjust button padding
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: TextStyle(
                                  fontSize: screenWidth * 0.05, // Adjust font size
                                  fontWeight: FontWeight.bold,
                                ),
                                shadowColor: Colors.blueAccent.withOpacity(0.3),
                                elevation: 8,
                              ),
                              child: const Text("Add City",style: TextStyle(color: Colors.white),),
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
