import 'package:assessment_task/language/ANG.dart';
import 'package:assessment_task/language/FR.dart';
import 'package:get/get_navigation/src/root/internacionalization.dart';

class Translation extends Translations{
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
      'ANG':ANG,
       'FR':FR,
  };
}