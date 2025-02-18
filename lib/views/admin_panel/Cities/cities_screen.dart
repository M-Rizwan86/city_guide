import 'package:city_guide/views/admin_panel/Cities/add_cities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CitiesScreen extends StatelessWidget {
  const CitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> cityStream =
        FirebaseFirestore.instance.collection("cities").snapshots();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Cities"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const AddCities();
                }));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: StreamBuilder(
          stream: cityStream, builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: Text("Loading..."));
        }
        if(snapshot.hasError){
          return Center(child: Text("${snapshot.error}"));
        }if(snapshot.hasData){
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context,index){
            DocumentSnapshot data = snapshot.data!.docs[index];
            return ListTile(
              title: Text(data["city"]),
              trailing: IconButton(onPressed: (){}, icon: Icon(Icons.edit,color: Colors.blue)),
            );
          });
        }


        return const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
