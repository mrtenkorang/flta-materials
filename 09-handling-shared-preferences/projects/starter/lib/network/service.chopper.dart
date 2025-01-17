// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$RecipeService extends RecipeService {
  _$RecipeService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = RecipeService;

  @override
  Future<Response<Result<ApiRecipeQuery>>> queryRecipes(
    String query,
    int from,
    int to,
  ) {
    final Uri $url = Uri.parse('search');
    final Map<String, dynamic> $params = <String, dynamic>{
      'q': query,
      'from': from,
      'to': to,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Result<ApiRecipeQuery>, ApiRecipeQuery>($request);
  }
}
