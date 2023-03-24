import 'package:fluent_ui/fluent_ui.dart';
import 'package:genos_dart/genos_dart.dart';

import '../models/modeldotationsglobales.dart';

class DotationProvider {
  static final DotationProvider _instance = DotationProvider._();
  static bool _initialized = false;

  DotationProvider._();

  static Future<DotationProvider> get instance async {
    if(!_initialized) {
      _initialized  = true;
    }
    return _instance;
  }

  Future<void> getAllDotation({
    required String? commId,
    required String? endDate,
    required String? startDate,
    required ValueChanged<List<Dotations>> onSuccess,
    required ValueChanged<RequestError> onError,
    bool secure = true,
  }) async {
    await GDirectRequest.select(
        sql: "SELECT COUNT(distinct(TO_POS_NAME)) as dotreg, CAST(TIMESTAMP AS DATE) AS jours "
            "FROM pso "
            "WHERE DATE(TIMESTAMP) >= '$startDate' AND DATE(TIMESTAMP) <= '$endDate'  AND FRMSISDN = '$commId' "
            "AND TOMSISDN IN (SELECT NUMERO_FLOOZ FROM univers) "
            "GROUP BY jours;"


    ).exec(
        secure: secure,
        onSuccess: (Result result) {
          List<Dotations> l = [];
          for (var element in result.data) {
            l.add(Dotations.MapDotations(element));
          }
          onSuccess(l);
        },
        onError: onError
    );
  }
}