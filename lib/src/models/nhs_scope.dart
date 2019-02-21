/// Scopes can be used to request that specific sets of information be made
/// available as Claim Values when making an Authentication Request
class NhsScope {
  const NhsScope._(this.value);

  final String value;

  /// Mandatory value for OpenID Connect Requests
  static const NhsScope openId = NhsScope._('openid');

  /// This scope value requests access to the End-User's default profile claims,
  /// which are: nhs_number, birthdate, family_name
  static const NhsScope profile = NhsScope._('profile');

  /// This scope value requests access to the phone_number and
  /// phone_number_verified claims
  static const NhsScope phone = NhsScope._('phone');

  /// This scope value requests access to the address claim as held within the
  /// NHS Personal Demographics Service
  @Deprecated(
      'Support for the address scope is currently under user research and '
      'evaluation.')
  static const NhsScope address = NhsScope._('address');

  /// This scope value requests access to the End-User's
  /// gp_integration_credentials claims
  @Deprecated(
      'Support for the gp_integration_credentials scope is currently under '
      'user research and evaluation.')
  static const NhsScope gpIntegrationCredentials =
      NhsScope._('gp_integration_credentials');

  /// This scope value requests access to the End-User’s gp_registration_details
  /// claims as held within the NHS Personal Demographics Service
  @Deprecated(
      'Support for the gp_integration_credentials scope is currently under '
      'user research and evaluation.')
  static const NhsScope gpRegistrationDetails =
      NhsScope._('gp_registration_details');

  /// This scope value requests access to the End-User’s additional demographics
  /// claims (as held within the NHS Personal Demographics Service), which are:
  /// given_name
  static const NhsScope profileExtended = NhsScope._('profile_extended');

  static const List<NhsScope> values = <NhsScope>[
    openId,
    profile,
    phone,
    address,
    gpIntegrationCredentials,
    gpRegistrationDetails,
    profileExtended,
  ];
  static const List<String> _names = <String>[
    'openId',
    'profile',
    'phone',
    'address',
    'gpIntegrationCredentials',
    'gpRegistrationDetails',
    'profileExtended',
  ];

  @override
  String toString() => value;

  factory NhsScope.forName(String it) {
    return values[_names.indexOf(it)];
  }
}
