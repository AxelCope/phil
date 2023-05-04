import 'package:phil/provider/db_constants.dart';

class UniversCount{
  int? countPdv;

  UniversCount({this.countPdv});


  factory UniversCount.mapUnivers(Map<String, dynamic> map) {
  return UniversCount(
    countPdv: map[univers],
  );
  }

}