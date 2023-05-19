import 'package:json_annotation/json_annotation.dart';
part 'recipe_model.g.dart';

// All you need to do is to define the fields you need and the json_annotatio library will convert these fields to json
// and from json

@JsonSerializable()
class ApiRecipeQuery{


  @JsonKey(name: 'q')
  String query;
  int from;
  int to;
  bool more;
  int count;
  List <APIHits> hits;

  ApiRecipeQuery({
    required this.query,
    required this.from,
    required this.to,
    required this.more,
    required this.count,
    required this.hits,
});
  factory ApiRecipeQuery.fromJson(Map<String, dynamic> json)=>_$ApiRecipeQueryFromJson(json);

  Map<String, dynamic> toJson() => _$ApiRecipeQueryToJson(this);
}

@JsonSerializable()
class APIHits {
  APIRecipe recipe;

  APIHits({required this.recipe});
   factory APIHits.fromJson(Map<String, dynamic> json) => _$APIHitsFromJson(json);

   Map<String, dynamic> toJson()=>_$APIHitsToJson(this);
}


@JsonSerializable()
class APIRecipe {

  String label;
  String image;
  String url;
  List<APIIngredients> ingredients;
  double calorie;
  double totalWeight;
  double totalTime;

  APIRecipe({
    required this.label,
    required this.image,
    required this.url,
    required this.ingredients,
    required this.calorie,
    required this.totalWeight,
    required this.totalTime,
});

  factory APIRecipe.fromJson(Map<String, dynamic>json) => _$APIRecipeFromJson(json);

  Map<String, dynamic> Function(APIRecipe instance) toJson() => _$APIRecipeToJson;

  // Converts the calorie into a string
  String getCalories(double? calorie){
    if( calorie == null){
      return '0 KCAl';
    }
    return '${calorie.floor()} KCAl';
  }

  // Convert the weight into a string
  String getWeight( double? weight){
    if(weight == null) {
      return '0g';
    }
    return '${weight.floor()}g';
  }
}


@JsonSerializable()
class APIIngredients {

  @JsonKey(name: 'text')
  String name;
  double weight;

  APIIngredients({
    required this.name,
    required this.weight,
});

  factory APIIngredients.fromJson(Map<String, dynamic> json) => _$APIIngredientsFromJson(json);

  Map<String, dynamic> toJson() => _$APIIngredientsToJson(this);
}

//ID: 30c93092
//Keys: 489c6d2bbf9a66d74016f81603b8d831	—
