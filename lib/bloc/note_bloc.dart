import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart' as sql;

class NoteBloc {
  static Future<void> createTable(sql.Database database) async {
    await database.execute("""CREATE Table notes(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      description TEXT,
      imageKey TEXT,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'notes.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        print('here');
        await createTable(database);
      },
    );
  }

  static Future<int> createItem({
    required String title,
    required String description,
    String? imageKey,
  }) async {
    final db = await NoteBloc.db();
    var data = {
      'title': title,
      'description': description,
      'imageKey': imageKey
    };
    var response = await db.insert(
      'notes',
      data,
    );
    return response;
  }

  static Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await NoteBloc.db();
    return db.query('notes', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getANote({required int id}) async {
    final db = await NoteBloc.db();
    return db.query('notes', where: 'id= ?', whereArgs: [id], limit: 1);
  }

  static Future<int> updateNote({required int id, required body}) async {
    final db = await NoteBloc.db();
    var data = {
      'title': body['item'],
      'description': body['description'],
      'imageKey': body['imageKey']
    };
    var response = await db.update(
      'notes',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
    return response;
  }

  static Future<void> deleteNote(num id) async {
    final db = await NoteBloc.db();
    try {
      await db.delete('notes', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint('Something went wrong');
    }
  }
}
