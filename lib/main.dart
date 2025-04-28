import 'package:isar_crud/models/story_database.dart';
import 'package:isar_crud/pages/list_story.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StoryDatabase.initialize();
  //await CharacterDatabase.initialize();

  runApp(
      ChangeNotifierProvider(
        create: (context) => StoryDatabase(),
        child: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StoryPage()
    );
  }
}
