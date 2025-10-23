import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'edit_user_profile_screen.dart';
import '../widgets/profile_header_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch user data when the screen loads
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Provider.of<UserProvider>(context, listen: false).fetchUser(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              if (userProvider.user != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditUserProfileScreen(user: userProvider.user!),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userProvider.user == null) {
            return const Center(child: Text('User not found.'));
          }

          final user = userProvider.user!;

          return SingleChildScrollView(
            child: Column(
              children: [
                ProfileHeaderWidget(
                  photoUrl: user.photoUrl,
                  displayName: user.displayName,
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Email'),
                  subtitle: Text(user.email),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Display Name'),
                  subtitle: Text(user.displayName ?? 'Not set'),
                ),
                ListTile(
                  leading: const Icon(Icons.description),
                  title: const Text('Description'),
                  subtitle: Text(user.description ?? 'Not set'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

