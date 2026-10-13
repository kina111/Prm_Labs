import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final photoUrl = user.photoURL;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: ClipOval(
            child: photoUrl == null
                ? const Icon(Icons.account_circle, size: 80)
                : Image.network(
                    photoUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        const Icon(Icons.account_circle, size: 80),
                  ),
          ),
        ),
        const SizedBox(height: 24),
        Text('Tên: ${user.displayName ?? "Chưa có tên"}'),
        const SizedBox(height: 12),
        Text('Email: ${user.email ?? "Chưa có email"}'),
        const SizedBox(height: 12),
        SelectableText('UID: ${user.uid}'),
      ],
    );
  }
}
