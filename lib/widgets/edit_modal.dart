import 'package:crud_riverpod/models/movie.dart';
import 'package:crud_riverpod/providers/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModalBottomSheet extends ConsumerStatefulWidget {
  final Movie movie;
  const ModalBottomSheet({super.key, required this.movie});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ModalBottomSheetState();
}

class _ModalBottomSheetState extends ConsumerState<ModalBottomSheet> {
  late Movie movie;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    movie = widget.movie;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a title',
                ),
                initialValue: movie.title,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Porfavor introduzca un texto";
                  }
                  return null;
                },
                onChanged: (value) {
                  movie.title = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a year',
                ),
                initialValue: movie.year,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Porfavor introduzca un texto";
                  }
                  return null;
                },
                onChanged: (value) {
                  movie.year = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
              ),
              TextFormField(
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a description',
                ),
                initialValue: movie.plot,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Porfavor introduzca un texto";
                  }
                  return null;
                },
                onChanged: (value) {
                  movie.plot = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context);

                      ref
                          .read(moviesProvider.notifier)
                          .updateMovie(movie.id, movie.toJson());
                    }
                  },
                  child: const Text("Guardar Cambios"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
