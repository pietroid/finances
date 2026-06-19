import 'package:app_ui/app_ui.dart';
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
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Column(
            spacing: AppSpacing.small,
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
