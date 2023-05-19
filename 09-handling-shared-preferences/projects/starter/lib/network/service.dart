import 'package:chopper/chopper.dart';
import '../../network/recipe_model.dart';
import '../../network/model_response.dart';
import '../../network/model_converter.dart';
part 'service.chopper.dart';

const String apiKey = '489c6d2bbf9a66d74016f81603b8d831';
const String apiId = '30c93092';
final apiUrl = Uri.parse('https://api.edamam.com');

@ChopperApi()
abstract class RecipeService extends ChopperService{

  @Get(path: 'search')

  Future<Response<Result<ApiRecipeQuery>>> queryRecipes(
      @Query('q') String query, @Query('from') int from, @Query('to') int to
      );

  static RecipeService create(){
    final client = ChopperClient(
      baseUrl: apiUrl,
      interceptors: [_addQuery, HttpLoggingInterceptor()],
      converter: ModelConverter(),
      errorConverter: const JsonConverter(),
      services: [
        _$RecipeService()
      ],
    );
    return _$RecipeService(client);
  }
}

// this function adds the apiId and Api key to the uri
Request _addQuery(Request request){
  final params = Map<String, dynamic>.from(request.parameters);

  params['api_id'] = apiId;
  params['app_key'] = apiKey;

  return request.copyWith(parameters: params);
}
