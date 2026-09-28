import 'package:dio/dio.dart';

import '../models/user_model.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://reqres.in',
      headers: {
        'x-api-key': const String.fromEnvironment(
          'REQRES_API_KEY',
          defaultValue: 'reqres-free-v1',
        ),
      },
      connectTimeout: const Duration(
        seconds: 15,
      ),
      receiveTimeout: const Duration(
        seconds: 15,
      ),
    ),
  );

  Future<List<UserModel>> fetchUsers() async {
    try {
      final response = await _dio.get(
        '/api/users',
        queryParameters: {
          'page': 1,
          'per_page': 10,
        },
      );

      final data = response.data['data'];

      if (data is! List) {
        throw Exception(
          'Format data dari server tidak sesuai.',
        );
      }

      return data
          .map(
            (json) => UserModel.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (e) {
      throw Exception(
        'Gagal mengambil data pengguna: ${e.message}',
      );
    } catch (e) {
      throw Exception(
        'Terjadi kesalahan: $e',
      );
    }
  }
}