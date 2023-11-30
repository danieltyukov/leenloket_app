import 'package:flutter/material.dart';

class AdminHomeView extends StatelessWidget {
  const AdminHomeView({super.key});

  static const routeName = '/admin/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          CustomButton(
            title: 'Add item',
            color: Colors.orange,
            onPressed: () {
              // TODO: Implement button 1 functionality
            },
          ),
          CustomButton(
            title: 'See all items',
            color: Colors.red,
            onPressed: () {
              // TODO: Implement button 2 functionality
            },
          ),
          CustomButton(
            title: 'See all bookings',
            color: Colors.green,
            onPressed: () {
              // TODO: Implement button 3 functionality
            },
          ),
          CustomButton(
            title: 'See all lockers',
            color: Colors.blue,
            onPressed: () {
              // TODO: Implement button 4 functionality
            },
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color color;

  const CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
