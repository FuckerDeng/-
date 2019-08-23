import 'package:bangwu_app/public/models/chapter.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "Chapter") {
      return Chapter.fromJson(json) as T;
    } else {
      return null;
    }
  }
}