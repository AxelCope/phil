import 'package:fluent_ui/fluent_ui.dart';
import 'package:genos_dart/genos_dart.dart';
import 'package:phil/models/model_reconversion.dart';

import '../models/modeldotationsglobales.dart';

class ReconversionProvider {
  static final ReconversionProvider _instance = ReconversionProvider._();
  static bool _initialized = false;

  ReconversionProvider._();

  static Future<ReconversionProvider> get instance async {
    if(!_initialized) {
      _initialized  = true;
    }
    return _instance;
  }

  Future<void> getAllReconversion({
    required String? commId,
    required String? endDate,
    required String? startDate,
    required ValueChanged<List<Rec>> onSuccess,
    required ValueChanged<RequestError> onError,

    bool secure = true,
  }) async {
    await GDirectRequest.select(
        sql: "SELECT SUM(AMOUNT) as reconversion, DATE(TIMESTAMP) AS jours "
            "FROM pso "
            "WHERE "
            "DATE(TIMESTAMP) >= '$startDate' AND DATE(TIMESTAMP) <= '$endDate' "
            "AND (FRMSISDN IN (SELECT NUMERO_FLOOZ FROM univers WHERE NUMERO_CAGNT = $commId) AND TOMSISDN = $commId) "
            "GROUP BY jours; "


    ).exec(
        secure: secure,
        onSuccess: (Result result) {
          List<Rec> l = [];
          for (var element in result.data) {
            l.add(Rec.MapComm(element));
          }
          onSuccess(l);
        },
        onError: onError
    );
  }
}