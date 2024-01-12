import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:note_app/bloc/note_bloc.dart';

import '../../../utils/helper.dart';
import '../../widgets/image_picker.dart';

class CreateOrUpdateNotesScreen extends StatefulWidget {
  final int? id;

  const CreateOrUpdateNotesScreen({super.key, this.id});

  @override
  State<CreateOrUpdateNotesScreen> createState() =>
      _CreateOrUpdateNotesScreenState();
}

class _CreateOrUpdateNotesScreenState extends State<CreateOrUpdateNotesScreen> {
  final formKey = GlobalKey<FormState>();

  final titleCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  String? imageKey;

  Map<String, dynamic> data = {};

  void getData() async {
    if (widget.id != null) {
      var data = await NoteBloc.getANote(id: widget.id!);
      setState(() => this.data = data.first);
    }
    print(data);
  }

  Future<void> _initializeData() async {
    getData();
    titleCtrl.text = '${data['title'] ?? ''}';
    descriptionCtrl.text = data['description'] ?? '';
    imageKey = data['imageKey'];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      titleCtrl.text = '${data['title'] ?? ''}';
      descriptionCtrl.text = data['description'] ?? '';
      imageKey = data['imageKey'];
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(widget.id == null ? 'Create Notes' : 'Update Notes'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: titleCtrl,
              keyboardType: TextInputType.text,
              style: textTheme.bodyLarge,
              inputFormatters: <TextInputFormatter>[
                CapitalizeEachWordFormatter(),
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
              ],
              decoration: const InputDecoration(hintText: 'Title'),
              validator: (text) {
                if (text?.trim().isEmpty ?? true) {
                  return 'This field cannot be empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: descriptionCtrl,
              keyboardType: TextInputType.text,
              style: textTheme.bodyLarge,
              decoration: const InputDecoration(hintText: 'Description'),
              validator: (text) {
                if (text?.trim().isEmpty ?? true) {
                  return 'This field cannot be empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            const Text('Upload image'),
            const SizedBox(height: 10),
            ImagePickerContainer(
              onPick: (context, path) async {
                if (path == null) return;
                imageKey = path.path;
                setState(() {});
              },
              child: imageKey == null
                  ? Container(
                      height: 100,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade400, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0x20707070),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.file_upload_outlined,
                                size: 20,
                                color: Colors.black.withOpacity(0.8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Click to upload Image',
                            style: textTheme.titleMedium!.copyWith(
                              fontStyle: FontStyle.normal,
                            ),
                          )
                        ],
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.file(
                          File(imageKey!),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () async {
            if (!(formKey.currentState?.validate() ?? true)) return;
            formKey.currentState?.save();

            if (widget.id == null) {
              await NoteBloc.createItem(
                title: titleCtrl.text,
                description: descriptionCtrl.text,
                imageKey: imageKey,
              );
            } else {
              var data = {
                'item': titleCtrl.text,
                'description': descriptionCtrl.text,
                'imageKey': imageKey,
              };
              await NoteBloc.updateNote(id: widget.id!, body: data);
            }
            Get.back();
          },
          child: const Text('Submit'),
        ),
      ),
    );
  }
}
