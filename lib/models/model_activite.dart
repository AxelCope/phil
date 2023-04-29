import '../provider/db_constants.dart';

class ModelActivite {
  int? actifs;
  int? inactifs;

  ModelActivite({
    this.actifs,
    this.inactifs,
  });


  factory ModelActivite.MapComm(Map<String, dynamic> map) {
    return ModelActivite(
      actifs: map[dbactifs],
      inactifs: map[dbinactifs],
    );
  }
}