import '../provider/db_constants.dart';

class Rec {
  String? dotation;

  Rec({
    this.dotation,
  });


  factory Rec.MapComm(Map<String, dynamic> map) {
    return Rec(
      dotation: map[dbRec],
    );
  }
}