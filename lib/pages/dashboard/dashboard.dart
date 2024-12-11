import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 30),
          child: Text(
            'Dashboard',
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}
