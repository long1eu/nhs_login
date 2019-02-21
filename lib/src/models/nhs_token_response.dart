import 'package:meta/meta.dart';
import 'package:nhs_login/src/models/nhs_response_error.dart';
import 'package:nhs_login/src/models/nhs_scope.dart';
import 'package:nhs_login/src/models/nhs_token_error.dart';

/// After receiving a valid and authorised Token request from the client, the
/// Token Endpoint returns a response which includes an ID Token and an Access
/// Token.
class NhsTokenResponse implements NhsResponseError<NhsTokenError> {
  const NhsTokenResponse({
    @required this.accessToken,
    @required this.tokenType,
    @required this.expiresIn,
    @required this.scope,
    @required this.idToken,
    @required this.error,
    @required this.errorDescription,
    @required this.errorUri,
  });

  factory NhsTokenResponse.fromJson(Map<String, dynamic> json) {
    return NhsTokenResponse(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      expiresIn: Duration(seconds: int.parse(json['expires_in'])),
      scope: List<String>.of(json['scope']).map((it) => NhsScope.forName(it)),
      idToken: json['id_token'],
      error: NhsTokenError.forName(json['error']),
      errorDescription: json['error_description'],
      errorUri: json['error_uri'],
    );
  }

  /// Signed JWT which encodes the Access Token, see sections 4.1 and 4.3
  final String accessToken;

  /// Must be value “bearer”
  final String tokenType;

  /// The lifetime of the access token.
  final Duration expiresIn;

  /// Identical to the scope requested by the client;
  final List<NhsScope> scope;

  /// Signed JWT which encodes the ID Token
  final String idToken;

  @override
  final NhsTokenError error;

  @override
  final String errorDescription;

  @override
  final String errorUri;

  @override
  String toString() {
    return 'NhsTokenResponse{'
        'accessToken: $accessToken, '
        'tokenType: $tokenType, '
        'expiresIn: $expiresIn, '
        'scope: $scope, '
        'idToken: $idToken, '
        'error: $error, '
        'errorDescription: $errorDescription, '
        'errorUri: $errorUri'
        '}';
  }
}
