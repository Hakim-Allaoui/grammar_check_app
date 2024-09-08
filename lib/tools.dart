import 'dart:convert';
import 'package:grammar_check_app/constants.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchConfig() async {
  final response = await http.get(
    Uri.parse(config_url),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load config');
  }
}
