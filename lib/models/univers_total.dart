import 'package:phil/provider/db_constants.dart';

class countUnivers{
  int? pdv_zone;

  countUnivers({
    this.pdv_zone,
});

  factory countUnivers.MapComm(Map<String, dynamic> map) {
    return countUnivers(
      pdv_zone: map[univers],
    );
  }

}