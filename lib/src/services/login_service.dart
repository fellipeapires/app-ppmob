// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:app_ppmob/src/shared/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class LoginApiService {
  static Future<dynamic> login(
    String username,
    String password,
  ) async {
    final client = http.Client();
    try {
      final response = await client.post(
        Uri.parse(Endpoint.authenticate),
        body: json.encode({'username': username, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['jwtToken'];
        if (kDebugMode) {
          print('Resposta do servidor: ${response.body}');
        }
        if (kDebugMode) {
          print('Token received: $token');
        }
        return token;
      } else {
        if (kDebugMode) {
          print('Failed to sign in. Status code: ${response.statusCode}');
        }
        return response.statusCode;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during Login: $e');
      }
    } finally {
      client.close();
    }
  }
}
