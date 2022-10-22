// package we need for json encode/decode
import 'dart:convert';

// service helper for loading json file
import 'package:flutter/services.dart' as rootBundle;

class MovieService {
  Future<List<dynamic>> fetchMovies() async {
    // Load json data
    final moviesData =
        await rootBundle.rootBundle.loadString('assets/data.json');
    // Decode json data to list
    return json.decode(moviesData) as List<dynamic>;
  }
}
