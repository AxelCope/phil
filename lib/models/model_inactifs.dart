import 'package:phil/provider/db_constants.dart';

class Inactifs{
  int? inactifs;

  Inactifs({
  this.inactifs,
  });


  factory Inactifs.MapInactifs(Map<String, dynamic> map) {
  return Inactifs(
  inactifs: map[dbinactifs],
  );
  }

}