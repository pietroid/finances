import 'package:finances/home/widgets/category_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 10,
            children: [
              CategoryCard(category: "Básico"),
              CategoryCard(category: "Compras"),
              CategoryCard(category: "Lazer"),
            ],
          ),
        ),
      ),
    );
  }
}
