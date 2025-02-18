import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';  // Import url_launcher

class AttractionDetailScreen extends StatelessWidget {
  final String name;
  final String description;
  final String imageUrl;
  final String location;
  final String category; // New field for category
  final String? date; // New optional field for date
  final String? time; // New optional field for time

  const AttractionDetailScreen({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.time,
    required this.location,
    required this.category,
    required this.date,
    Key? key,
  }) : super(key: key);


  Future<void> _launchMaps() async {
      final Uri url = Uri.parse('${location}');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not open the map.';
      }
    }


  @override
  Widget build(BuildContext context) {
    // Format the date if it is not null
    String formattedDate = 'N/A';
    if (date != null && date!.isNotEmpty) {
      try {
        // Convert the string to a DateTime object and format it
        DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(date!);  // Assuming the date format is yyyy-MM-dd
        formattedDate = DateFormat('d-M-yyyy').format(parsedDate);  // Change to d-M-yyyy format
      } catch (e) {
        // If the date format is incorrect, keep it as 'N/A'
        formattedDate = 'N/A';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    color: Colors.black.withOpacity(0.6),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: Offset(0, 4), // Shadow position
                              ),
                            ],
                          ),
                          child: Text(
                            description,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.6,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  if (category == 'Event') ...[
                    const Text(
                      'Date & Time',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Date: $formattedDate',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Time: ${time ?? 'N/A'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Button to open Google Maps with the provided latitude and longitude
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _launchMaps,
                      icon: const Icon(Icons.directions,color: Colors.white,),
                      label: const Text('Get Location',style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                  ),
                  SizedBox(height: 100,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
