import 'package:flutter/material.dart';
import 'package:lab2/screens/MealListScreen.dart';
import 'package:lab2/screens/RecipeDetailScreen.dart';
import 'package:lab2/services/ApiService.dart';
import '../models/category.dart';

class CategoryListScreen extends StatefulWidget {
  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final ApiService apiService = ApiService();
  List<Category> categories = [];
  List<Category> filteredCategories = [];
  bool loading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  void getCategories() async {
    var result = await apiService.fetchCategories();
    setState(() {
      categories = result;
      filteredCategories = categories;
      loading = false;
    });
  }

  void searchCategories(String query) {
    List<Category> filtered = [];
    for (int i = 0; i < categories.length; i++) {
      if (categories[i].name.toLowerCase().contains(query.toLowerCase())) {
        filtered.add(categories[i]);
      }
    }
    setState(() {
      filteredCategories = filtered;
    });
  }

  void openRandomRecipe() async {
    var recipe = await apiService.fetchRandomRecipe();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipe: recipe),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Categories'),
        actions: [
          IconButton(
            icon: Icon(Icons.shuffle),
            onPressed: openRandomRecipe,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: searchController,
              onChanged: searchCategories,
              decoration: InputDecoration(
                hintText: 'Search categories...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: filteredCategories.length,
        itemBuilder: (context, index) {
          var category = filteredCategories[index];
          String desc = category.description;
          if (desc.length > 80) {
            desc = desc.substring(0, 80) + '...';
          }
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: Image.network(
                category.thumbnail,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
              title: Text(category.name),
              subtitle: Text(desc),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MealListScreen(category: category.name),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}