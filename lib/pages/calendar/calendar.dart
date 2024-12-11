import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

   @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 30),
          child: Text(
            'Calendário',
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}