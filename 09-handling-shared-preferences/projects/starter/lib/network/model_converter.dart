import 'dart:convert';
import 'model_response.dart';
import 'recipe_model.dart';
import 'package:chopper/chopper.dart';

// Custom converter for encoding and decoding requests and responses
class ModelConverter implements Converter {
  @override
  Request convertRequest(Request request) {
    final req = applyHeader(
      request,
      contentTypeKey,
      jsonHeaders,
      override: false,
    );
    return encodeJson(req);
  }

  // Encodes the request body to JSON if the content type is JSON
  Request encodeJson(Request request) {
    final contentType = request.headers[contentTypeKey];

    if (contentType != null && contentType.contains(jsonHeaders)) {
      return request.copyWith(body: json.encode(request.body));
    }

    return request;
  }

  // Decodes the response body from JSON and handles any errors
  Response<BodyType> decodeJson<BodyType, InnerType>(Response response) {
    final contentType = response.headers[contentTypeKey];
    var body = response.body;

    if (contentType != null && contentType.contains(jsonHeaders)) {
      body = utf8.decode(response.bodyBytes);
    }

    try {
      final mapData = json.decode(body);

      if (mapData['status'] != null) {
        // If the response contains a 'status' field, treat it as an error
        return response.copyWith<BodyType>(
            body: Error(Exception(mapData['status'])) as BodyType);
      }

      // Deserialize the response body into an APIRecipeQuery object
      final recipeQuery = ApiRecipeQuery.fromJson(mapData);

      return response.copyWith<BodyType>(
          body: Success(recipeQuery) as BodyType);
    } catch (e) {
      // Handle any decoding or parsing errors
      chopperLogger.warning(e);
      return response.copyWith<BodyType>(
          body: Error(e as Exception) as BodyType);
    }
  }

  @override
  Response<BodyType> convertResponse<BodyType, InnerType>(Response response) {
    return decodeJson<BodyType, InnerType>(response);
  }
}
