class Recipe {
  final String id;
  final String name;
  final String instructions;
  final String thumbnail;
  final String youtubeUrl;
  final Map<String, String> ingredients;

  Recipe({
    required this.id,
    required this.name,
    required this.instructions,
    required this.thumbnail,
    required this.youtubeUrl,
    required this.ingredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    // Extract ingredients and measures
    Map<String, String> ingredients = {};
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null && ingredient.isNotEmpty && measure != null && measure.isNotEmpty) {
        ingredients[ingredient] = measure;
      }
    }

    return Recipe(
      id: json['idMeal'],
      name: json['strMeal'],
      instructions: json['strInstructions'],
      thumbnail: json['strMealThumb'],
      youtubeUrl: json['strYoutube'] ?? '',
      ingredients: ingredients,
    );
  }
}
