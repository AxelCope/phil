import '../provider/db_constants.dart';

class Comms {
  String? nomCommerciaux;
  String id;
  DateTime? startDateTime;
  DateTime? endDateTime;

  Comms({
    this.nomCommerciaux,
    this.id = '',
    this.startDateTime,
    this.endDateTime,
  });


  factory Comms.MapComm(Map<String, dynamic> map) {
    return Comms(
      nomCommerciaux: map[dbName],
      id: map[dbId],
      startDateTime: DateTime(2023, 03, 13),
      endDateTime: DateTime.now(),
    );
  }
}