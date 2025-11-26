import 'package:flutter/material.dart';
import 'package:lab2/screens/CategoryListScreen.dart';

void main() {
  runApp(RecipeApp());
}

class RecipeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Recipes',
      theme: ThemeData(primarySwatch: Colors.green),
      home: CategoryListScreen(),
    );
  }
}
