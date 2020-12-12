import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';
import '../widgets/create_profile_card.dart';

class CreateProfileScreen extends StatelessWidget {
  static const routeName = '/create-profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Profile'),
      ),
      drawer: AppDrawer(),
      body: CreateProfileCard(),
    );
  }
}