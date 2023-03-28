import 'package:genos_dart/genos_dart.dart';

class QueriesProvider {
  static final QueriesProvider _instance = QueriesProvider._();
  static bool _initialized = false;

  QueriesProvider._();

  static Future<QueriesProvider> get instance async {
    if (!_initialized) {
      _initialized = true;
    }
    return _instance;
  }



  Future<void> fetchCommerciaux({
    required Function(List<Map<String, dynamic>>) onSuccess,
    required Function(RequestError) onError,
    bool secure = true
  }) async {
    GDirectRequest.select(
      sql: "SELECT POS_NICKCNAME as surnom, NOM_COMMERCIAL as nom, POS_MSIDSN as id FROM COMMERCIALS WHERE POS_NICKCNAME != 'PHIL-RECLAMATIONS ET GIVE' AND POS_NICKCNAME != 'SUPERVISEUR PHIL NORD032'  AND POS_NICKCNAME != 'PHIL-SECURE-AGNT' ",
    ).exec(
        secure: secure,
        onSuccess: (Result result) {

          onSuccess(result.data);
        },
        onError: onError
    );
  }

  Future<void> fetchRegions({
    required Function(List<Map<String, dynamic>>) onSuccess,
    required Function(RequestError) onError,
    bool secure = true
  }) async {
    GDirectRequest.select(
      sql: 'SELECT region, COUNT(numero_flooz) AS nbp FROM univers GROUP BY region',
    ).exec(
        secure: secure,
        onSuccess: (Result result) {
          onSuccess(result.data);
        },
        onError: onError
    );
  }


  Future<void> fetchCommerciauxNbPdvs({
    required cmNickName,
    required Function(List<Map<String, dynamic>>) onSuccess,
    required Function(RequestError) onError,
    bool secure = true
  }) async {
    GDirectRequest.select(
        values: [cmNickName],
        sql: "SELECT COUNT(NUMERO_FLOOZ) as nbpdv FROM univers WHERE CAGNT = ?")
        .exec(
        secure: secure,
        onSuccess: (Result result) {
          onSuccess(result.data);
        },
        onError: onError
    );
  }

  Future<void> Dots({
    required cmId,
    required Function(List<Map<String, dynamic>>) onSuccess,
    required Function(RequestError) onError,
    bool secure = true
  }) async {
    GDirectRequest.select(
        values: [cmId],
        sql:
        "SELECT COUNT(DISTINCT(TO_POS_NAME)) AS dotations"
        "FROM pso"
        "WHERE (DATE(TIMESTAMP) = '2023-03-20')"
        "AND (FRMSISDN = 22896370801)"
        "AND (TOMSISDN IN (SELECT NUMERO_FLOOZ FROM univers));)")
        .exec(
        secure: secure,
        onSuccess: (Result result) {
          onSuccess(result.data);
        },
        onError: onError
    );
  }

  Future<void> Reconversion({
    required cmId,
    required String? endDate,
    required String? startDate,
    required Function(List<Map<String, dynamic>>) onSuccess,
    required Function(RequestError) onError,
    bool secure = true
  }) async {
    GDirectRequest.select(
        values: [cmId],
        sql: "SELECT SUM(AMOUNT)"
            "FROM pso"
            "WHERE"
            "DATE(TIMESTAMP) >= $startDate AND DATE(TIMESTAMP) <= $endDate"
        "AND (FRMSISDN IN (SELECT NUMERO_FLOOZ FROM univers WHERE NUMERO_CAGNT = $cmId) AND TOMSISDN = $cmId);"
    )
        .exec(
        secure: secure,
        onSuccess: (Result result) {
          onSuccess(result.data);
        },
        onError: onError
    );
  }

  Future<void> fetchCommerciauxZone({
    required cmNickName,
    required Function(List<Map<String, dynamic>>) onSuccess,
    required Function(RequestError) onError,
    bool secure = true
  }) async {
    GDirectRequest.select(
      values: [cmNickName],
      sql: "SELECT NOM_DU_POINT AS points FROM univers WHERE CAGNT = ?",
    ).exec(
        secure: secure,
        onSuccess: (Result result) {
          onSuccess(result.data);
        },
        onError: onError
    );
  }

  Future<void> fetchPdvActifs({
    required Function(List<Map<String, dynamic>>) onSuccess,
    required Function(RequestError) onError,
    bool secure = true
  }) async {
    GDirectRequest.select(
        sql:
        'SELECT  COUNT(DISTINCT(NOM_DU_POINT)) as NREF '
            'FROM univers'
            'WHERE NUMERO_FLOOZ IN (SELECT frmsisdn FROM pso WHERE DATE(TIMESTAMP) >= "2023-01-01" ) OR NUMERO_FLOOZ  IN (SELECT tomsisdn FROM pso WHERE DATE(TIMESTAMP) >= "2023-01-01" )'

    ).exec(
        secure: secure,
        onSuccess: (Result result) {
          onSuccess(result.data);
        },
        onError: onError
    );
  }

}
