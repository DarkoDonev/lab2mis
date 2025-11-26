import 'package:flutter/material.dart';
import 'package:lab2/screens/RecipeDetailScreen.dart';
import 'package:lab2/services/ApiService.dart';
import '../models/meal.dart';

class MealListScreen extends StatefulWidget {
  final String category;

  MealListScreen({required this.category});

  @override
  _MealListScreenState createState() => _MealListScreenState();
}

class _MealListScreenState extends State<MealListScreen> {
  ApiService apiService = ApiService();
  List<Meal> meals = [];
  List<Meal> filteredMeals = [];
  bool loading = true;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getMeals();
  }

  void getMeals() async {
    var result = await apiService.fetchMealsByCategory(widget.category);
    setState(() {
      meals = result;
      filteredMeals = meals;
      loading = false;
    });
  }

  void filterMeals(String query) async {
    if (query.isEmpty) {
      setState(() {
        filteredMeals = meals;
      });
    } else {
      var result = await apiService.searchMeals(query);
      List<Meal> temp = [];
      for (var i = 0; i < result.length; i++) {
        if (result[i].id.isNotEmpty) {
          temp.add(result[i]);
        }
      }
      setState(() {
        filteredMeals = temp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meals: ${widget.category}'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: searchController,
              onChanged: filterMeals,
              decoration: InputDecoration(
                hintText: 'Search meals...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ),
      body: loading == true
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
        ),
        itemCount: filteredMeals.length,
        itemBuilder: (context, index) {
          Meal meal = filteredMeals[index];
          return GestureDetector(
            onTap: () async {
              var recipe = await apiService.fetchRecipeById(meal.id);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailScreen(recipe: recipe),
                ),
              );
            },
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.network(
                      meal.thumbnail,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      meal.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}