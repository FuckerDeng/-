import 'package:bangwu_app/public/models/fiction_detail_page_model_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "FictionDetailPageModelEntity") {
      return FictionDetailPageModelEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}