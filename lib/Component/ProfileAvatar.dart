import 'dart:io';

import 'package:flutter/material.dart';

class Profileavatar extends StatelessWidget {
  final String? profilePhotoUrl;
  final Function onPressed;

  const Profileavatar({required this.profilePhotoUrl, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: profilePhotoUrl != null
          ? FileImage(File(profilePhotoUrl!))
          : AssetImage('assets/images/default_profile.png') as ImageProvider,
      radius: 20,
      backgroundColor: Colors.white,
      child: IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: () => onPressed(),
      ),
    );
  }
}
