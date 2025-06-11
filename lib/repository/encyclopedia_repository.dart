import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:ppb_fp_9/models/species_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EncyclopediaRepository extends GetxController {
  static EncyclopediaRepository get instance => Get.find();

  final String _baseUrl = "https://trefle.io";
  final String _apiKey = dotenv.env['TREFLE_KEY'] ?? "YOUR_SECRET_API_KEY";

  Future<List<SpeciesModel>> getAllPlants({required int page}) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/v1/plants?token=$_apiKey&page=$page');
      // print("Calling $uri");
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // print("OK");
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('data')) {
          final List<dynamic> speciesJson = data['data'];
          // print("Has Data ${speciesJson.length}");
          return speciesJson.map((json) => SpeciesModel.fromJson(json)).toList();
        } else {
          throw Exception('API response did not contain a "data" key.');
        }
      } else {
        throw Exception('Failed to load plants from API. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred while fetching plants: ${e.toString()}');
    }
  }

  Future<SpeciesModel> getSinglePlant({required int plantId}) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/v1/plants/$plantId?token=$_apiKey');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('data')) {
          final dynamic speciesJson = data['data'];
          return SpeciesModel.fromJson(speciesJson);
        } else {
          throw Exception('API response did not contain a "data" key.');
        }

      } else {
        throw Exception('Failed to load plant details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred while fetching plant details: ${e.toString()}');
    }
  }
}
