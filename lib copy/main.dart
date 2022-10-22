import 'package:crud_riverpod/models/movie.dart';
import 'package:crud_riverpod/providers/model.dart';
import 'package:crud_riverpod/widgets/movie_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent));
  runApp(
    //*ALmacena el estado de todos los provider
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = ThemeData();

    List<Movie> formattedMovies = ref.watch(moviesProvider).movies;
    bool isLoading = ref.watch(moviesProvider).isLoading;

    return MaterialApp(
        theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            primary: Colors.black,
            secondary: Colors.blue,
          ),
        ),
        title: 'Le Movie App',
        home: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a search term',
                    ),
                    onChanged: (text) async {
                      // text here is the inputed text
                      await ref
                          .read(moviesProvider.notifier)
                          .filterMovies(text);
                    },
                  ),
                ),
                isLoading
                    ? CircularProgressIndicator()
                    : Expanded(
                        child: Container(
                            color: Colors.white,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: formattedMovies.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Movie movie = formattedMovies[index];

                                  return MovieCard(movie: movie);
                                })),
                      )
              ],
            ),
          ),
        ));
  }
}
