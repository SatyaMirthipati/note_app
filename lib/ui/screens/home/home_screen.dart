import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/bloc/note_bloc.dart';
import 'package:share_plus/share_plus.dart';

import 'create_or_update_notes_screen.dart';
import 'note_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> data = [];

  void getData() async {
    var data = await NoteBloc.getNotes();
    setState(() => this.data = data);
  }

  @override
  void initState() {
    super.initState();
    getData();
    print('Data ${data.length}');
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: ListView.builder(
        itemCount: data.length,
        padding: const EdgeInsets.all(20),
        itemBuilder: (BuildContext context, int index) {
          print(data[index]['id'].toString());
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 5),
            color: Colors.redAccent.shade100,
            elevation: 10,
            child: ListTile(
              onTap: () {
                Get.to(
                  () {
                    return NoteDetailsScreen(
                      id: int.parse('${data[index]['id']}'),
                    );
                  },
                );
              },
              leading: data[index]['imageKey'] != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.file(
                        File(data[index]['imageKey']),
                        fit: BoxFit.fill,
                        width: 40,
                        height: 40,
                      ),
                    )
                  : null,
              title:
                  Text('${data[index]['title']}', style: textTheme.bodyLarge),
              subtitle: Text(
                '${data[index]['description']}',
                style: textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      Share.share(
                        data[index]['description'],
                        subject: data[index]['title'],
                      );
                    },
                    icon: Icon(Icons.share),
                  ),
                  IconButton(
                    onPressed: () async {
                      await NoteBloc.deleteNote(
                          int.parse('${data[index]['id']}'));
                      getData();
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.to(() {
            return const CreateOrUpdateNotesScreen();
          });
          setState(() => getData());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
