import 'package:crud_riverpod/models/movie.dart';
import 'package:crud_riverpod/providers/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteButton extends ConsumerStatefulWidget {
  const DeleteButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends ConsumerState<DeleteButton> {
  late Movie movie;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Borrar ${movie.title.toString()}"),
            content: const Text("Seguro de querer borra el elemento?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, "Cancel"),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => deleteMovie(movie.id, ref, context),
                child: const Text("Ok"),
              )
            ],
          ),
        );
      },
      child: Text("Borrar"),
    );
  }

  deleteMovie(movieId, WidgetRef ref, context) {
    ref.read(moviesProvider.notifier).deleteMovie(movieId);
    Navigator.pop(context);
  }
}
