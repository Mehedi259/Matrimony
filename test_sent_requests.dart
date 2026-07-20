import 'dart:convert';
import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzg1ODEzNzY5LCJpYXQiOjE3ODQ1MTc3NjksImp0aSI6IjdlYTQyZjlmNzY5MDQwMzk4MDdkZmQ2ZmFlNDBjZGE4IiwidXNlcl9pZCI6ImE1ZDY5ZTk1LWY0NDUtNDAwOS04ZTYwLWJlOGExYmI0NDhlNiJ9.LtAkttnEHdAz6Qszai-dQ0KyeFyS7IroD6s5uNLQfY4';
  
  try {
    final response = await dio.get('https://api.amuslimmatchmaker.com/api/matches/requests/sent/');
    print('Status: ${response.statusCode}');
    if (response.data is List) {
      print('Count: ${(response.data as List).length}');
      print('Data: ${jsonEncode(response.data)}');
    }
  } catch (e) {
    print(e);
  }
}
