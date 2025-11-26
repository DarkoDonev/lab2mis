import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailScreen({required this.recipe});

  Widget getIngredients() {
    List<Widget> ingredientWidgets = [];
    recipe.ingredients.entries.forEach((entry) {
      ingredientWidgets.add(Text('${entry.value} ${entry.key}'));
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ingredientWidgets,
    );
  }

  void openYoutube() async {
    var url = recipe.youtubeUrl;
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(recipe.thumbnail),
            SizedBox(height: 12),
            Text(
              'Ingredients:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            getIngredients(),
            SizedBox(height: 12),
            Text(
              'Instructions:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(recipe.instructions),
            SizedBox(height: 12),
            recipe.youtubeUrl.isNotEmpty
                ? ElevatedButton.icon(
              onPressed: openYoutube,
              icon: Icon(Icons.video_library),
              label: Text('Watch on YouTube'),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}