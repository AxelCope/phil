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
      sql: "SELECT POS_NICKCNAME as surnom, NOM_COMMERCIAL as nom, POS_MSIDSN as id, adresse_mail as mail FROM COMMERCIALS WHERE POS_NICKCNAME != 'PHIL-RECLAMATIONS ET GIVE' AND POS_NICKCNAME != 'SUPERVISEUR PHIL NORD032'  AND POS_NICKCNAME != 'PHIL-SECURE-AGNT' ",
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
        sql:
        "SELECT SUM(AMOUNT) as reconversion, DATE(TIMESTAMP) AS jours "
            "FROM pso "
            "WHERE "
            "DATE(TIMESTAMP) >= '$startDate' AND DATE(TIMESTAMP) <= '$endDate' "
            "AND (FRMSISDN IN (SELECT NUMERO_FLOOZ FROM univers WHERE NUMERO_CAGNT = $cmId) AND TOMSISDN = $cmId) "
            "GROUP BY jours; "
    )
        .exec(
        secure: secure,
        onSuccess: (Result result) {
          onSuccess(result.data);
        },
        onError: onError
    );
  }

  Future<void> fetchActifsZone({
    required cmId,
    required startDate,
    required endDate,
    required Function(List<Map<String, dynamic>>) onSuccess,
    required Function(RequestError) onError,
    bool secure = true
  }) async {
    GDirectRequest.select(
      sql: "SELECT COUNT(NOM_DU_POINT) as inactifs "
        "FROM univers "
          "WHERE (numero_cagnt = $cmId) AND "
          "(NUMERO_FLOOZ NOT IN (SELECT frmsisdn FROM pso WHERE DATE(TIMESTAMP) >= '$startDate') "
    " OR NUMERO_FLOOZ NOT IN (SELECT tomsisdn FROM pso WHERE DATE(TIMESTAMP) >= '$endDate' ));" ,
    ).exec(
        secure: secure,
        onSuccess: (Result result) {
          onSuccess(result.data);
        },
        onError: onError
    );
  }

  Future<void> Pdvszones({
    required cmId,
    required Function(List<Map<String, dynamic>>) onSuccess,
    required Function(RequestError) onError,
    bool secure = true
  }) async {
    GDirectRequest.select(
      values: [cmId],
      sql: "SELECT COUNT(numero_flooz) as pdvs "
        "FROM univers "
        "WHERE numero_cagnt = ? ; ",
    ).exec(
        secure: secure,
        onSuccess: (Result result) {
          onSuccess(result.data);
        },
        onError: onError
    );
  }




  Future<void> Segmentation({
    required cmId,
    required date,
     required Function(List<Map<String, dynamic>>) onSuccess,
    required Function(RequestError) onError,
    bool secure = true
  }) async {
    GDirectRequest.select(
      sql: "SELECT SUM(fr_amount) AS somme, frmsisdn as id, fr_pos_name as nom "
          "FROM "
      "( "
      "SELECT SUM(amount) AS fr_amount, frmsisdn, fr_pos_name "
      "FROM pso "
      "WHERE TYPE = 'CSIN'  AND frmsisdn IN (SELECT numero_flooz FROM univers where numero_cagnt = $cmId) AND MONTH(TIMESTAMP) = '$date' "
    "GROUP BY frmsisdn "
        "UNION ALL "
    "SELECT SUM(amount) AS to_amount, tomsisdn, to_pos_name "
    "FROM pso "
    "WHERE TYPE = 'AGNT'  AND tomsisdn IN (SELECT numero_flooz FROM univers where numero_cagnt = $cmId) AND MONTH(TIMESTAMP) = '$date' "
        "GROUP BY tomsisdn "
        ") tbl "
        "GROUP BY frmsisdn;"

    ).exec(
        secure: secure,
        onSuccess: (Result result) {
          onSuccess(result.data);
        },
        onError: onError
    );
  }

  Future<void> Retrait({
    required cmId,
    required Function(List<Map<String, dynamic>>) onSuccess,
    required Function(RequestError) onError,
    bool secure = true
  }) async {
    GDirectRequest.select(
      values: [cmId],
      sql: "SELECT SUM(amount) as somme, to_pos_name as nom, tomsisdn"
          " FROM pso"
          " WHERE TYPE = 'AGNT'  AND tomsisdn IN (SELECT numero_flooz FROM univers WHERE NUMERO_CAGNT = ?) AND DATE(TIMESTAMP) >= '2023-04-01' "
          " GROUP BY to_pos_name;"
    ).exec(
        secure: secure,
        onSuccess: (Result result) {
          onSuccess(result.data);
        },
        onError: onError
    );
  }

  Future<void> fetchInactifsZone({
    required cmId,
    required startDate,
    required Function(List<Map<String, dynamic>>) onSuccess,
    required Function(RequestError) onError,
    bool secure = true
  }) async {
    GDirectRequest.select(
      sql:
        "SELECT NOM_DU_POINT as nom, NUMERO_FLOOZ as id "
        "FROM univers "
            "WHERE (NUMERO_FLOOZ NOT IN (SELECT frmsisdn FROM pso WHERE MONTH(TIMESTAMP) = '$startDate' ) AND NUMERO_FLOOZ NOT IN (SELECT tomsisdn FROM pso WHERE DATE(TIMESTAMP) = '$startDate')) "
      "AND numero_cagnt =  $cmId; "
    ,
    ).exec(
        secure: secure,
        onSuccess: (Result result) {
          onSuccess(result.data);
        },
        onError: onError
    );
  }

  Future<void> fetchUnivers({
    required pdvId,
    id,
    required Function(List<Map<String, dynamic>>) onSuccess,
    required Function(RequestError) onError,
    bool secure = true
  }) async {
    GDirectRequest.select(
      sql:
          "SELECT profil, longitude, latitude, localisation  "
          "FROM univers "
          "WHERE NUMERO_FLOOZ = $pdvId;",
    ).exec(
        secure: secure,
        onSuccess: (Result result) {
          onSuccess(result.data);
        },
        onError: onError
    );
  }


}