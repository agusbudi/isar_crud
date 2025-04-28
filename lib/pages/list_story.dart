import 'package:flutter/material.dart';
import '../models/story.dart';
import '../models/story_database.dart';
import 'package:provider/provider.dart';
import 'detail_story.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({super.key});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  final textController = TextEditingController();
  final descController = TextEditingController();
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    readNotes();
  }


  @override
  Widget build(BuildContext context) {
    // note database
    final noteDatabase = context.watch<StoryDatabase>();

    // current notes
    List<Story> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
        appBar: AppBar(title: Text(
            'StoryBase',
            style: TextStyle(
              color: Colors.blueAccent[400],
              fontSize: 30,
              fontWeight: FontWeight.bold,)
        ), backgroundColor: Colors.yellowAccent,),
        backgroundColor: Colors.greenAccent[70],
        floatingActionButton: FloatingActionButton(
          onPressed: createNote,
          child: const Icon(Icons.add),
        ),
        body:
            Stack(
              children: [
            // Background image
            Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1521728935364-00584c026397?q=80&w=3915&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              fit: BoxFit.cover,
            ),
        ),
        // Semi-transparent overlay (optional for readability)


    ListView.separated(
          itemCount: currentNotes.length,
          itemBuilder: (context, index) {
            // get individual note
            final note = currentNotes[index];

            // list tile UI
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(note.urlImage), // No matter how big it is, it won't overflow
              ),
              title: Text(note.text),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ListItemPage(note.text, note.description, note.urlImage)));
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // edit button
                  IconButton(
                      onPressed: () => updateNote(note),
                      icon: const Icon(Icons.edit)),
                  // delete button
                  IconButton(
                    onPressed:
                        () => showDialog<String>(
                      context: context,
                      builder:
                          (BuildContext context) => AlertDialog(
                        title: const Text('Delete Note'),
                        content: Text('Are you sure to delete ' + note.text + '?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              deleteNote(note.id);
                              Navigator.pop(context, 'OK');
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    ),
                    icon: const Icon(Icons.delete)
                  ),
                      // onPressed: () => deleteNote(note.id),
                      // icon: const Icon(Icons.delete))
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        ),
    ],
    )
    );
  }

  // create a note
  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            children:  [
              TextField(
                controller: textController,
                decoration: InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: descController,
                maxLines: 5, //or null
                decoration: InputDecoration(labelText: "Story"),
              ),
              TextField(
                controller: urlController,
                decoration: InputDecoration(labelText: "Image URL"),
              ),
            ],
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              // add to db
              context.read<StoryDatabase>().addNote(textController.text, descController.text, urlController.text);

              // clear controller
              textController.clear();
              descController.clear();
              urlController.clear();

              Navigator.pop(context);
            },
            child: const Text("Create"),
          )
        ],
      ),
    );
  }

  // update a note
  void updateNote(Story note) {
    textController.text = note.text;
    descController.text = note.description;
    urlController.text = note.urlImage;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Update Story"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: textController,
                  decoration: InputDecoration(labelText: "Story Title"),
                ),
                TextField(
                  controller: descController,
                  maxLines: 5, //or null
                  decoration: InputDecoration(labelText: "Description"),
                ),
                TextField(
                  controller: urlController,
                  decoration: InputDecoration(labelText: "Image URL"),
                ),
              ],
            ),
          ),
          actions: [
            MaterialButton(
                onPressed: () {
                  context
                      .read<StoryDatabase>()
                      .updateNote(note.id, textController.text,descController.text, urlController.text);
                  // clear controller
                  textController.clear();
                  descController.clear();
                  urlController.clear();

                  Navigator.pop(context);
                },
                child: const Text("Update"))
          ],
        ));
  }

  void deleteNote(int id) {
    context.read<StoryDatabase>().deleteNote(id);
  }

  void readNotes() {
    context.read<StoryDatabase>().fetchNotes(); // Use read instead of watch
  }

}