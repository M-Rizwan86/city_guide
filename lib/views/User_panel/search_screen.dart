import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _searchResults = [];
  bool _isLoading = false;

  Future<void> _searchAttractions(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Adjusted Firestore query
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('attraction')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      // Filter results if needed
      final filteredResults = snapshot.docs.where((doc) {
        final data = doc.data();
        return data['category'] == 'desiredCategory'; // Replace or remove as needed
      }).toList();

      setState(() {
        _searchResults = filteredResults;
      });
    } catch (e) {
      print('Error occurred during search: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred during search')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Attractions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Input Field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _searchAttractions(value);
              },
            ),
            SizedBox(height: 16),
            // Search Results
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty
                ? Center(child: Text('No attractions found'))
                : Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  var data = _searchResults[index].data();
                  return Card(
                    child: ListTile(
                      leading: Image.network(
                        data['imagepath'] ?? '',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.broken_image),
                      ),
                      title: Text(data['name'] ?? 'Unknown'),
                      subtitle: Text(data['description'] ?? 'No description'),
                      onTap: () {
                        print("Selected: ${data['name']}");
                        // Navigate or perform action
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
