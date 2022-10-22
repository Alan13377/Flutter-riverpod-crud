// package we need for json encode/decode
import 'dart:convert';

// service helper for loading json file
import 'package:dio/dio.dart';
import 'package:flutter/services.dart' as rootBundle;

class MovieService {
  final Dio _dio = Dio(
    BaseOptions(
        baseUrl: "https://635459cdccce2f8c02078ef8.mockapi.io",
        headers: {"Access-Control-Allow-Origin": "*"}),
  );

  Future<List<dynamic>> fetchMovies([filter = ""]) async {
    final movieData = await _dio.get(
      "/movies?Title=$filter",
    );
    return movieData.data;
  }

  Future<dynamic> fetchMovie(id) async {
    final movieData = await _dio.get("/movies/$id");
    return movieData.data;
  }

  Future<dynamic> updateMovie(id, movieData) async {
    try {
      final response = await _dio.put("/movies/$id", data: movieData);
      return response.data;
    } on DioError catch (error) {
      throw error;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<dynamic> deleteMovie(id) async {
    try {
      final response = await _dio.delete("/movies/$id");
      return response.data;
    } on DioError catch (error) {
      throw error;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<dynamic> fetchLocalMovies() async {
    await Future.delayed(Duration(seconds: 1));

    final moviesData =
        await rootBundle.rootBundle.loadString("assets/data.json");
    return json.decode(moviesData) as List<dynamic>;
  }
}
