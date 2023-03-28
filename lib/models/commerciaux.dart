import '../provider/db_constants.dart';

class Comms {
  String? nomCommerciaux;
  String id;

  Comms({
    this.nomCommerciaux,
    this.id = '',
  });


  factory Comms.MapComm(Map<String, dynamic> map) {
    return Comms(
      nomCommerciaux: map[dbName],
      id: map[dbId],
    );
  }
}