import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiKey = "replace_your_key"; // 🔑 Your API Key
  static const String baseUrl = "https://api.api-ninjas.com/v1/nutrition?query=";

  // Function to fetch nutrition data
  static Future<List<dynamic>> fetchNutritionData(String query) async {
    final response = await http.get(
      Uri.parse("$baseUrl$query"),
      headers: {"X-Api-Key": apiKey}, // Add API Key in headers
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Convert JSON to List
    } else {
      throw Exception("Error: ${response.statusCode} - ${response.body}");
    }
  }
}
