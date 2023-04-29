import '../provider/db_constants.dart';

class Rec {
  double? reconversion;
  String? date;
  DateTime? startDateTime;
  DateTime? endDateTime;

  Rec({
    this.reconversion,
    this.startDateTime,
    this.endDateTime,
    this.date,
  });


  factory Rec.MapComm(Map<String, dynamic> map) {
    return Rec(
      reconversion: map[dbRec],
      date: map[dbDates],
      startDateTime: DateTime(2023, 03, 13),
      endDateTime: DateTime.now(),
    );
  }
}