import 'package:phil/provider/db_constants.dart';

class InactifsDistincts{
  int? numero_flooz;
  String? nom_pdv;

  InactifsDistincts({
    this.numero_flooz,
    this.nom_pdv,
  });


  factory InactifsDistincts.MapInactifs(Map<String, dynamic> map) {
    return InactifsDistincts(
      numero_flooz: map[dbId],
      nom_pdv: map[dbNom],
    );
  }

}