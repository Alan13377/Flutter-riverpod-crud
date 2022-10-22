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
    final moviesList = await MovieService().fetchMovies();
    // Convert list to list of movies using the movie class constructor
    final movies = moviesList.map((e) => Movie.fromJson(e)).toList();
    // Update state in provider
    state = state.copyWith(movies: movies, isLoading: false);
  }

  Future<Movie> loadMovie(id) async {
    final movieData = await MovieService().fetchMovie(id);
    final movie = Movie.fromJson(movieData);
    return movie;
  }

  filterMovies(filter) async {
    state = state.copyWith(isLoading: true);

    final moviesList = await MovieService().fetchMovies(filter);
    // Convert list to list of movies using the movie class constructor with simple filter title function inside
    final movies = moviesList.map((e) => Movie.fromJson(e)).toList();

    state = state.copyWith(movies: movies, isLoading: false);
  }

  updateMovie(id, movieData) async {
    final movieJson = await MovieService().updateMovie(id, movieData);
    final movie = Movie.fromJson(movieJson);

    final index = state.movies.indexWhere((element) => element.id == movie.id);
    final movies = List<Movie>.from(state.movies);
    movies[index] = movie;
    state = state.copyWith(movies: movies, isLoading: false);
  }

  deleteMovie(id) async {
    //state = state.copyWith(isLoading: true);
    final movieJson = await MovieService().deleteMovie(id);
    // Convert list to list of movies using the movie class constructor

    final index = state.movies.indexWhere((element) => element.id == id);
    final movies = List<Movie>.from(state.movies);
    movies.removeAt(index);
    // Update state in provider
    state = state.copyWith(movies: movies, isLoading: false);
  }
}
