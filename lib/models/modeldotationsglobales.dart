import '../provider/db_constants.dart';

class Dotations {
  int dotations;
  String dates;
  DateTime? startDate;
  DateTime? endDate;

  Dotations({
      this.dates = "",
      this.dotations = 0,
     this.startDate,
     this.endDate,
  });


  factory Dotations.MapDotations(Map<String, dynamic> map) {
    return Dotations(
      dotations: map[dbRegContent],
      dates: map[dbDates],
    );
  }

}