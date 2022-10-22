import 'dart:convert';

import 'package:crud_riverpod/models/movie.dart';
import 'package:crud_riverpod/services/movie_services.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
//*Servicio para leer un jsonfile
import 'package:flutter/services.dart' as rootBundle;
import "package:freezed_annotation/freezed_annotation.dart";
part 'model.freezed.dart';

// Creating state where the freezed annotation
@freezed
class MovieState with _$MovieState {
  factory MovieState({
    @Default([]) List<Movie> movies,
    @Default(true) bool isLoading,
  }) = _MovieState;

  const MovieState._();
}

//**Creando state notifier provider */

final moviesProvider =
    StateNotifierProvider<MovieNotifier, MovieState>((ref) => MovieNotifier());

//*Creando Notifier

class MovieNotifier extends StateNotifier<MovieState> {
  MovieNotifier() : super(MovieState()) {
    loadMovies();
  }
  loadMovies() async {
    state = state.copyWith(isLoading: true);
    //*Cargar la data del json
    // final moviesData =
    //     await rootBundle.rootBundle.loadString("assets/data.json");
    final moviesList = await MovieService().fetchMovies();

    //*Convirtiendo la lista de peliculas
    final movies = moviesList.map((e) => Movie.fromJson(e)).toList();

    //*Actualizar el estado del provider
    state = state.copyWith(movies: movies, isLoading: false);
  }

  filterMovies(filter) async {
    state = state.copyWith(isLoading: true);
    // Load json data
    // final moviesData =
    //     await rootBundle.rootBundle.loadString('data/movies.json');
    // Decode json data to list
    final moviesList = await MovieService().fetchMovies();
    // Convert list to list of movies using the movie class constructor with simple filter title function inside
    final movies = moviesList
        .map((e) => Movie.fromJson(e))
        .toList()
        .where((element) =>
            element.title!.toLowerCase().contains(filter.toLowerCase()))
        .toList();

    state = state.copyWith(movies: movies, isLoading: false);
  }
}
