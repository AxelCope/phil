import 'package:phil/provider/db_constants.dart';

class Segmentation{
  double? somme;
  String? nom;
  int? id;

  Segmentation({
    this.somme,
    this.nom,
    this.id,
});


  factory Segmentation.MapDepot(Map<String, dynamic> map) {
    return Segmentation(
        somme: map[dbSomme],
        nom: map[dbNom],
        id: map[dbId]
    );
    }
}