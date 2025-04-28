import 'package:isar_crud/models/story.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class StoryDatabase extends ChangeNotifier{
  static late Isar isar;

  // INIT
  static Future<void> initialize() async {
    if (Platform.isAndroid) { // Check if it's Android
      final dir = await getApplicationDocumentsDirectory();
      isar = await Isar.open([StorySchema], directory: dir.path);
    } else {
      // Handle other platforms or provide a default directory
      final dir = getTemporaryDirectory(); // Example for other platforms
      isar = await Isar.open([StorySchema], directory: (await dir).path);
    }
  }

  // list
  final List<Story> currentNotes = [];

  // create
  Future<void> addNote(String textFromUser, String descFromUser, String urlFromUser) async {
    // create a new object
    final newNote = Story()
      ..text = textFromUser
      ..description = descFromUser
      ..urlImage = urlFromUser;

    // save to db
    await isar.writeTxn(() => isar.storys.put(newNote));

    // re-read from db
    fetchNotes();
  }
  // read
  Future<void> fetchNotes() async {
    List<Story> fetchedNotes = await isar.storys.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);
    notifyListeners();
  }
  // update
  Future<void> updateNote(int id, String newText, String newDesc, String newURL) async {
    final existingNote = await isar.storys.get(id);
    if (existingNote != null) {
      existingNote.text = newText;
      existingNote.description = newDesc;
      existingNote.urlImage = newURL;
      await isar.writeTxn(() => isar.storys.put(existingNote));
      await fetchNotes();
    }
  }
  // delete
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.storys.delete(id));
    await fetchNotes();
  }
}