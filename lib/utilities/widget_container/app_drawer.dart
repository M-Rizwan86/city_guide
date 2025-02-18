import 'package:city_guide/views/admin_panel/user_screen.dart';
import 'package:city_guide/views/auth_screen/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/auth_controller.dart';
import '../../provider/change_theme_provider.dart';
import '../constraints/contraints.dart';

class AppBarDrawer extends StatefulWidget {
  const AppBarDrawer({super.key});

  @override
  State<AppBarDrawer> createState() => _AppBarDrawerState();
}

class _AppBarDrawerState extends State<AppBarDrawer> {
  CollectionReference userData = FirebaseFirestore.instance.collection('Users');
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final User = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Drawer(
      child: Column(
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: userData.doc(FirebaseAuth.instance.currentUser?.uid).get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              // Waiting state
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const UserAccountsDrawerHeader(
                  currentAccountPicture:
                      CircleAvatar(child: Icon(Icons.person)),
                  accountEmail: Center(child: CircularProgressIndicator()),
                  accountName: Center(child: CircularProgressIndicator()),
                );
              }

              // Error state
              else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              // No data or document doesn't exist
              else if (!snapshot.hasData || snapshot.data == null) {
                return const UserAccountsDrawerHeader(
                  currentAccountPicture:
                      CircleAvatar(child: Icon(Icons.person)),
                  accountEmail: Text("No Email"),
                  accountName: Text("Guest"),
                );
              }

              // Data available
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>? ?? {};

              // Handle case where data might be incomplete
              String username = data['username'] ?? 'Guest';
              String email = data['email'] ?? 'No Email';

              return UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.bgColor],
                  ),
                ),
                accountName: Text(
                  username,
                  style: TextStyle(
                      fontSize: screenWidth * 0.05), // Scaled font size
                ),
                accountEmail: Text(
                  email,
                  style: TextStyle(
                      fontSize: screenWidth * 0.04), // Scaled font size
                ),
                currentAccountPicture: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
              );
            },
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserScreen(),
                  ));
            },
            child: const ListTile(
              leading: Icon(Icons.verified_user),
              title: Text('Users'),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.rate_review),
            title: Text('Reviews & Ratings'),
          ),
          ListTile(
            leading: const Icon(Icons.nightlight_outlined),
            title: const Text('Dark Mode'),
            trailing: Consumer<ChangeTheme>(
              builder: (_, themeProvider, __) {
                return Switch(
                  value: themeProvider.isdark,
                  onChanged: (_) {
                    themeProvider.setTheme();
                  },
                );
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: InkWell(
              onTap: () {
                if (User == null) {
                  // Navigate to the sign-in screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                } else {
                  // Sign out the user
                  _firebaseAuthService.signOut(context);
                }
              },
              child: Text(
                User == null ? 'Sign In' : 'Logout',
                style:
                    TextStyle(color: User == null ? Colors.blue : Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
