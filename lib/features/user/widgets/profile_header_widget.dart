import 'package:flutter/material.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String? photoUrl;
  final String? displayName;

  const ProfileHeaderWidget({
    super.key,
    this.photoUrl,
    this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        CircleAvatar(
          radius: 50,
          backgroundImage: (photoUrl != null && photoUrl!.isNotEmpty)
              ? NetworkImage(photoUrl!)
              : null,
          child: (photoUrl == null || photoUrl!.isEmpty)
              ? const Icon(Icons.person, size: 50)
              : null,
        ),
        const SizedBox(height: 10),
        Text(
          displayName ?? 'Guest',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

