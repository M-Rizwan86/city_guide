import 'package:city_guide/utilities/widget_container/achievement_view.dart';
import 'package:city_guide/views/admin_panel/Admin_Attraction/attraction_screen.dart';
import 'package:flutter/material.dart';

import '../../../controller/attraction_controller.dart';

class EditAttractionScreen extends StatefulWidget {
  final dynamic data;

  const EditAttractionScreen({super.key, this.data});

  @override
  State<EditAttractionScreen> createState() => _EditAttractionScreenState();
}

class _EditAttractionScreenState extends State<EditAttractionScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imgPathController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
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
    _nameController.text = widget.data['name'] ?? '';
    _descriptionController.text = widget.data['description'] ?? '';
    _imgPathController.text = widget.data['imagepath'] ?? '';
    _locationController.text = widget.data['location'] ?? '';
    selectedCity = widget.data['City'] ?? '';
    selectedCategory = widget.data['category'] ?? '';
    // selectedTime = stringToTimeOfDay(widget.data['time']);
    selectedDate = widget.data['date'] != null
        ? DateTime.tryParse(widget.data['date'])
        : null;
  }

  /// Utility function to convert a String to TimeOfDay
  TimeOfDay? stringToTimeOfDay(String? timeString) {
    if (timeString == null || !timeString.contains(':')) return null;
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imgPathController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Attractions'),
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
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.05,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Edit Attraction',
                  style: TextStyle(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
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
                          TextFormField(
                            controller: _nameController,
                            maxLines: 1,
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
                                return 'Please enter Attraction Name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          TextFormField(
                            controller: _imgPathController,
                            maxLines: 1,
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
                                return 'Please enter Image Path';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight * 0.02),
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
                                return 'Please enter Description';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          DropdownButtonFormField<String>(
                            value: selectedCity,
                            items: cities
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item),
                                    ))
                                .toList(),
                            onChanged: (value) =>
                                setState(() => selectedCity = value),
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
                              if (value == null || value.isEmpty) {
                                return 'Please select a City';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          DropdownButtonFormField<String>(
                            value: selectedCategory,
                            items: ['Event', 'Hotel', 'Restaurant']
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item),
                                    ))
                                .toList(),
                            onChanged: (value) =>
                                setState(() => selectedCategory = value),
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
                              if (value == null || value.isEmpty) {
                                return 'Please select a Category';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          if (selectedCategory == 'Event')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2030),
                                      initialDate:
                                          selectedDate ?? DateTime.now(),
                                    );
                                    if (pickedDate != null) {
                                      setState(() => selectedDate = pickedDate);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade50),
                                  child: Text(
                                    selectedDate != null
                                        ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                                        : "Select Date",
                                    style: const TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime:
                                          selectedTime ?? TimeOfDay.now(),
                                    );
                                    if (pickedTime != null) {
                                      setState(() => selectedTime = pickedTime);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade50),
                                  child: Text(
                                    selectedTime != null
                                        ? "${selectedTime!.hour}:${selectedTime!.minute}"
                                        : "Select Time",
                                    style: const TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: screenHeight * 0.03),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _locationController,
                                  decoration: InputDecoration(
                                    labelText: 'location Link',
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
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter Location path';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  // Show loading indicator while performing update
                                  setState(() {
                                    isLoading = true;
                                  });

                                  // Validate that Date and Time are selected if the category is "Event"
                                  if (selectedCategory == 'Event') {
                                    if (selectedDate == null) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      showAchievementView(context,
                                          message:
                                              "Please select a date for the Attraction",
                                          title: 'Alert',
                                          icon: Icons.dangerous);
                                      return;
                                    }
                                    if (selectedTime == null) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      showAchievementView(context,
                                          message:
                                              'Please select a time for the eventAttraction',
                                          title: 'Alert',
                                          icon: Icons.dangerous);
                                      return;
                                    }
                                  }

                                  // Proceed to update the attraction
                                  attractionController.updateAttraction(
                                    widget.data.id,
                                    _nameController.text,
                                    _descriptionController.text,
                                    selectedTime != null
                                        ? '${selectedTime!.hour}:${selectedTime!.minute}'
                                        : '',
                                    selectedCategory ?? '',
                                    _locationController.text,
                                    selectedDate?.toIso8601String() ?? '',
                                    selectedCity ?? '',
                                    _imgPathController.text,
                                    context,
                                  );

                                  // After the update, navigate back to the Attraction Screen
                                  Navigator.pop(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AttractionScreen(),
                                      ));

                                  // Hide loading spinner once done
                                  setState(() {
                                    isLoading = false;
                                  });
                                } else {
                                  showAchievementView(context,
                                      message:
                                          "Please fill all the required fields",
                                      title: 'Alert',
                                      icon: Icons.dangerous);
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
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors
                                          .white) // Show loading indicator if isLoading is true
                                  : const Text(
                                      "Update Attraction",
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
