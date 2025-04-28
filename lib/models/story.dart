// models/story.dart
import 'package:isar/isar.dart';

// this line is needed to generate file
// then run dart run build_runner build
part 'story.g.dart';

@Collection()
class Story {
  Id id = Isar.autoIncrement;
  late String text;
  late String urlImage;
  late String description;
}