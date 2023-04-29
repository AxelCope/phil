import '../provider/db_constants.dart';

class Comms {
  String? nomCommerciaux;
  String id;
  String? mail;
  DateTime? startDateTime;
  DateTime? endDateTime;
  DateTime? startDateTimeR;
  DateTime? endDateTimeR;

  Comms({
    this.nomCommerciaux,
    this.id = '',
    this.startDateTime,
    this.endDateTime,
    this.startDateTimeR,
    this.endDateTimeR,
    this.mail,

  });


  factory Comms.MapComm(Map<String, dynamic> map) {
    return Comms(
      nomCommerciaux: map[dbName],
      id: map[dbId],
      startDateTime: DateTime.now().subtract(Duration(days: 7)),
      endDateTime: DateTime.now(),
      startDateTimeR: DateTime.now().subtract(Duration(days: 7)),
      endDateTimeR: DateTime.now(),
      mail: map[dbMail],
    );
  }
}