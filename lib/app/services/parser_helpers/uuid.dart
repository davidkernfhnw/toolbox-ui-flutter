import 'package:uuid/uuid.dart';

class Uuids {
  // ----- Helpers
  static String get uuid {
    ///Generate a v4 (random) id
    return Uuid().v4();
  }
}
