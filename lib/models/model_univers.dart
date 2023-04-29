import 'package:phil/provider/db_constants.dart';

class Univers{
  String? profil;
  String? longitude;
  String? latitude;
  String? localisation;

  Univers({
     this.profil,
    this.latitude,
    this.longitude,
    this.localisation
});

  factory Univers.mapUnivers(Map<String, dynamic> map) {
    return Univers(
    profil: map[dbProfil],
        longitude: map[dbLongitude],
      latitude: map[dbLatitude],
      localisation: map[dbLocalisation]
    );
  }
}