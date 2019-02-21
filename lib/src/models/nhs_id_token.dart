import 'package:meta/meta.dart';

/// An ID Token is a security token that contains Claims about the
/// Authentication of an End-User by the Platform, when using a Client and
/// potentially other requested Claims.
///
/// The Access Token is a credential that can be used by an application to
/// access an API – initially the UserInfo endpoint.
///
/// The NHS login Platform uses signed JSON Web Tokens (JWTs) for ID Tokens and
/// Access Tokens. Other tokens, for example Refresh tokens are not supported.
class NhsIdToken {
  const NhsIdToken({
    @required this.header,
    @required this.payload,
    @required this.signature,
  });

  factory NhsIdToken.fromJson(Map<String, dynamic> json) {
    return NhsIdToken(
      header: NhsIdTokenHeader.fromJson(json['header']),
      payload: NhsIdTokenPayload.fromJson(json['payload']),
      signature: json['signature'],
    );
  }

  final NhsIdTokenHeader header;
  final NhsIdTokenPayload payload;
  final String signature;
}

class NhsIdTokenHeader {
  const NhsIdTokenHeader({
    @required this.algorithm,
    @required this.type,
  });

  factory NhsIdTokenHeader.fromJson(Map<String, dynamic> json) {
    return NhsIdTokenHeader(
      algorithm: json['alg'],
      type: json['typ'],
    );
  }

  /// Algorithm used for signing the JWT
  /// {alg}
  ///
  /// “RS512” – RSASSA-PKCS1-v1_5 with the SHA-512 hash algorithm
  final String algorithm;

  /// Type
  /// {typ}
  ///
  /// “JWT”
  final String type;
}

/// The following Claims are used within the ID Token for all Oauth 2.0 flows
/// used by OpenID Connect.
class NhsIdTokenPayload {
  const NhsIdTokenPayload({
    @required this.issuer,
    @required this.sub,
    @required this.audience,
    @required this.expiration,
    @required this.issuedAt,
    @required this.jwtId,
    @required this.authenticationTime,
    @required this.nonce,
    @required this.vectorOfTrust,
    @required this.vectorTrustMark,
    @required this.familyName,
    @required this.birthdate,
    @required this.nhsNumber,
  });

  factory NhsIdTokenPayload.fromJson(Map<String, dynamic> json) {
    return NhsIdTokenPayload(
      issuer: json['iss'],
      sub: json['sub'],
      audience: json['aud'] is List ? json['aud'] : <String>[json['aud']],
      expiration: DateTime.fromMillisecondsSinceEpoch(json['exp']),
      issuedAt: DateTime.fromMillisecondsSinceEpoch(json['iat']),
      jwtId: json['jti'],
      authenticationTime: json['auth_time'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['auth_time']),
      nonce: json['nonce'],
      vectorOfTrust: json['vot'],
      vectorTrustMark: json['vtm'],
      familyName: json['family_name'],
      birthdate:
          json['birthdate'] == null ? null : DateTime.parse(json['birthdate']),
      nhsNumber: json['nhs_number'],
    );
  }

  /// Issuer Identifier for the Issuer of the response
  /// {iss}
  ///
  /// The iss value is a case sensitive URL using the https scheme that contains
  /// scheme, host, and optionally, port number and path components and no query
  /// or fragment components.
  final String issuer;

  /// Subject Identifier
  /// {sub}
  ///
  /// A locally unique and never reassigned identifier within the Issuer for the
  /// End-User, which is intended to be consumed by the Client, e.g., 24400320
  /// or AitOawmwtWwcT0k51BayewNvutrJUqsvl6qs7A4
  ///
  /// It MUST NOT exceed 255 ASCII characters in length. The sub value is a case
  /// sensitive string
  final String sub;

  /// Audience(s) that this ID Token is intended for
  /// {aud}
  ///
  /// It MUST contain the Oauth 2.0 client_id of the Partner Services as an
  /// audience value. It MAY also contain identifiers for other audiences. In
  /// the general case, the aud value is an array of case sensitive strings. In
  /// the common special case when there is one audience, the aud value MAY be a
  /// single case sensitive string
  final List<String> audience;

  /// Expiration time on or after which the ID Token MUST NOT be accepted for processing
  /// {exp}
  ///
  /// The processing of this parameter requires that the current date/time MUST
  /// be before the expiration date/time listed in the value. Implementers MAY
  /// provide for some small leeway, usually no more than a few minutes, to
  /// account for clock skew.
  final DateTime expiration;

  /// Time at which the JWT was issued
  /// {iat}
  final DateTime issuedAt;

  /// JWT unique identifier
  /// {jti}
  ///
  /// Value is unique to each token created by the issuer
  final String jwtId;

  /// Time when the End-User authentication occurred
  /// {auth_time}
  ///
  /// This Claim is provided when a max_age request is made or when auth_time is
  /// requested as an Essential Claim.
  ///
  /// (The auth_time Claim semantically corresponds to the OpenID 2.0 PAPE [10]
  /// auth_time response parameter.)
  final DateTime authenticationTime;

  /// String value used to associate a Client session with an ID Token, and to
  /// mitigate replay attacks
  /// {nonce}
  ///
  /// The value is passed through unmodified from the Authentication Request to
  /// the ID Token.
  ///
  /// * If present in the ID Token, Clients MUST verify that the nonce Claim
  /// Value is equal to the value of the nonce parameter sent in the
  /// Authentication Request.
  ///
  /// The nonce value is a case sensitive string
  final String nonce;

  /// Vectors of Trust
  /// {vot}
  ///
  /// The level to which the user’s identity has been verified.
  final String vectorOfTrust;

  /// Vector Trust Mark
  /// {vtm}
  ///
  /// Https URI of the vtm claim
  final String vectorTrustMark;

  /// Family Name
  /// {family_name}
  ///
  /// Surname(s) or last name(s) of the End-User
  final String familyName;

  /// Birthdate
  /// {birthdate}
  ///
  /// The user’s date of birth is available
  final DateTime birthdate;

  /// NHS Number
  /// {nhs_number}
  ///
  /// If the user’s NHS Number is known, then it will be included. Will be
  /// represented as a 10-digit string.
  final String nhsNumber;
}
