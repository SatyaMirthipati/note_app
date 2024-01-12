import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/ui/screens/home/create_or_update_notes_screen.dart';

import '../../../bloc/note_bloc.dart';

class NoteDetailsScreen extends StatefulWidget {
  final int id;

  const NoteDetailsScreen({super.key, required this.id});

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  Map<String, dynamic> data = {};

  void getData() async {
    var data = await NoteBloc.getANote(id: widget.id);
    setState(() => this.data = data.first);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text('Note Details'),
        actions: [
          TextButton(
            onPressed: () {
              Get.to(() => CreateOrUpdateNotesScreen(id: widget.id));
            },
            child: Text(
              'Edit',
              style: textTheme.labelLarge!.copyWith(color: Colors.white),
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(data['title'] ?? 'NA', style: textTheme.titleLarge),
          const SizedBox(height: 10),
          Text(data['description'] ?? 'NA', style: textTheme.titleSmall),
          if (data['imageKey'] != null) ...[
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.file(
                  File(data['imageKey']),
                  fit: BoxFit.fitWidth,
                ),
              ),
            )
          ],
        ],
      ),
    );
  }
}
