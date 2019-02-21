/// Requests that the NHS login Service forces the user to sign-in, or to
/// request that the Service does not prompt the user to sign-in (SSO)
class NhsPrompt {
  const NhsPrompt._(this.value);

  final String value;

  /// The Service will SSO the user if they still have a valid session, else
  /// the user will be requested to login
  static const NhsPrompt blank = NhsPrompt._('');

  /// The Service will SSO the user if they still have a valid session,
  /// otherwise an error code is returned
  static const NhsPrompt none = NhsPrompt._('none');

  /// The Service will request the user to login, regardless of a session
  /// already existing
  static const NhsPrompt login = NhsPrompt._('login');

  static const List<NhsPrompt> values = <NhsPrompt>[
    blank,
    none,
    login,
  ];

  @override
  String toString() => value;
}
