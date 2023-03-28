import '../provider/db_constants.dart';

class Dots {
  String? dotation;

  Dots({
    this.dotation,
  });


  factory Dots.MapComm(Map<String, dynamic> map) {
    return Dots(
      dotation: map[dbDotations],
    );
  }
}