import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:recipe_app/Models/recipeModel.dart';

class ApiCall {
    String appId = "66d96ec9";
    String appKey = "f0ccb0e8f13edcfcb6924f1a5c598824";
    List<RecipeModel> recipeList = List<RecipeModel>();

    Future<void> getRecipe(String value) async {
        String url = "https://api.edamam.com/search?q=${value}&app_id=${appId}&app_key=${appKey}&from=0&to=20&calories=591-722&health=alcohol-free";
        var response = await http.get(url);
        if(response.statusCode == 200) {
            Map<String, dynamic> jsonData = jsonDecode(response.body);
            jsonData["hits"].forEach((element) {
                //print("hits are : $element");
                RecipeModel recipe = new RecipeModel();
                recipe = RecipeModel.fromMap(element["recipe"]);
                print("recipe : $recipe");
                recipeList.add(recipe);
            });
        }
    }
}