class NhsUserinfoError {
  const NhsUserinfoError._(this._value);

  factory NhsUserinfoError.fromName(String error) {
    if (error == null) {
      return null;
    }

    final int index = _names.indexOf(error);

    if (index == -1) {
      throw ArgumentError.value(error, 'error');
    }

    return values[index];
  }

  final String _value;

  /// The request is missing a required parameter, includes an unsupported
  /// parameter or parameter value, repeats the same parameter, uses more than
  /// one method for including an access token, or is otherwise malformed.
  static const NhsUserinfoError invalidRequest =
      NhsUserinfoError._('invalid_request');

  /// The access token provided is expired, revoked, malformed, or invalid for
  /// other reasons.
  ///
  /// The client MAY request a new access token and retry the protected resource
  /// request.
  static const NhsUserinfoError invalidToken =
      NhsUserinfoError._('invalid_token');

  /// The request requires higher privileges than provided by the access token.
  static const NhsUserinfoError insufficientScope =
      NhsUserinfoError._('insufficient_scope');

  static const List<NhsUserinfoError> values = <NhsUserinfoError>[
    invalidRequest,
    invalidToken,
    insufficientScope,
  ];

  static const List<String> _names = <String>[
    'invalid_request',
    'invalid_token',
    'insufficient_scope',
  ];

  @override
  String toString() => _value;
}
