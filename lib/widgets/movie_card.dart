import 'package:crud_riverpod/providers/model.dart';
import 'package:crud_riverpod/widgets/delete.dart';
import 'package:crud_riverpod/widgets/edit_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/movie.dart';

class MovieCard extends ConsumerWidget {
  const MovieCard({Key? key, required this.movie}) : super(key: key);

  final Movie movie;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
                padding: const EdgeInsets.all(10),
                height: 200,
                color: const Color(0xfff7f7f7),
                child: Row(children: <Widget>[
                  Container(
                    width: 80,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.network(movie.poster.toString()),
                  ),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(children: <Widget>[
                            GestureDetector(
                                onTap: () => context.push('/${movie.id}'),
                                child: Text("${movie.title} (${movie.year})",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18))),
                            const SizedBox(height: 10),
                            Text(movie.plot.toString(),
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 3),
                            Spacer(),
                            Row(
                              children: [
                                //*Editar
                                ElevatedButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return ModalBottomSheet(
                                              movie: movie,
                                            );
                                          });
                                    },
                                    child: Text("Edit")),
                                Padding(padding: EdgeInsets.all(15)),

                                //**Borrar */
                                ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color.fromARGB(255, 66, 59, 58)),
                                    ),
                                    onPressed: () => showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: Text(
                                                'Delete ${movie.title.toString()}'),
                                            content: const Text(
                                                'Are you sure you want to delete this movie?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'Cancel'),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () => deleteMovie(
                                                    movie.id, ref, context),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                        ),
                                    child: Text("Delete"))
                              ],
                            )
                          ])))
                ]))));
  }
}

deleteMovie(movieId, WidgetRef ref, BuildContext context) {
  ref.read(moviesProvider.notifier).deleteMovie(movieId);
  Navigator.pop(context);
}
