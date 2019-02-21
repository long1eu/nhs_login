import 'package:meta/meta.dart';
import 'package:nhs_login/src/models/authentication/nhs_scope.dart';
import 'package:nhs_login/src/models/nhs_response_error.dart';
import 'package:nhs_login/src/models/userinfo/nhs_userinfo_error.dart';

class NhsUserinfo implements NhsResponseError<NhsUserinfoError> {
  const NhsUserinfo({
    @required this.issuer,
    @required this.audience,
    @required this.sub,
    @required this.familyName,
    @required this.givenName,
    @required this.email,
    @required this.emailVerified,
    @required this.phoneNumber,
    @required this.phoneNumberVerified,
    @required this.birthdate,
    @required this.address,
    @required this.nhsNumber,
    @required this.gpIntegrationCredentials,
    @required this.delegations,
    @required this.gpRegistrationDetails,
    @required this.error,
    @required this.errorDescription,
  });

  factory NhsUserinfo.fromJson(Map<String, dynamic> json) {
    return NhsUserinfo(
      issuer: json['iss'],
      audience: json['aud'],
      sub: json['sub'],
      familyName: json['family_name'],
      givenName: json['given_name'],
      email: json['email'],
      emailVerified: json['email_verified'],
      phoneNumber: json['phone_number'],
      phoneNumberVerified: json['phone_number_verified'],
      birthdate: DateTime.parse(json['birthdate']),
      address: json['address'] == null
          ? null
          : NhsAddressField.fromJson(json['address']),
      nhsNumber: json['nhs_number'],
      gpIntegrationCredentials: json['gp_integration_credentials'] == null
          ? null
          : GpIntegrationCredentials.fromJson(
              json['gp_integration_credentials']),
      delegations: json['delegations'],
      gpRegistrationDetails: json['gp_registration_details'] == null
          ? null
          : GpRegistrationDetails.fromJson(json['gp_registration_details']),
      error: NhsUserinfoError.fromName(json['error']),
      errorDescription: json['error_description'],
    );
  }

  /// Issuer Identifier for the Issuer of the response
  /// {iss}
  final String issuer;

  /// The Partner Service identifier
  /// {aud}
  final String audience;

  /// Subject - Identifier for the End-User at the Issuer.
  /// {sub}
  final String sub;

  /// Surname(s) or last name(s) of the End-User
  /// {family_name}
  final String familyName;

  /// First name(s) of the End-User.
  /// {given_name}
  ///
  /// This information will only be returned where the user’s identity has been
  /// verified AND the [NhsScope.profileExtended] scope is requested AND the
  /// user consents to the claim being returned
  ///
  /// NOTE: Support for this claim is currently under user research and
  /// evaluation
  final String givenName;

  /// End-User's preferred e-mail address
  /// {email}
  ///
  /// Present if [NhsScope.email] was present in the request
  final String email;

  /// True if the End-User's e-mail address has been verified; otherwise false
  /// {email_verified}
  ///
  /// Present if [NhsScope.email] was present in the request
  final String emailVerified;

  /// End-User's preferred phone number
  /// {phone_number}
  ///
  /// Present if [NhsScope.phone] was present in the request AND the user
  /// consents to the claim being returned
  final String phoneNumber;

  /// True if the End-User's phone number has been verified; otherwise false
  /// {phone_number_verified}
  ///
  /// Present if [NhsScope.phone] was present in the request AND the user
  /// consents to the claim being returned
  final String phoneNumberVerified;

  /// End-User’s date of birth
  /// {birthdate}
  final DateTime birthdate;

  /// End-User’s home address as held in the NHS Personal Demographics Service.
  /// {address}
  ///
  /// This information will only be returned where the user’s identity has been
  /// verified AND the [NhsScope.address] scope is requested AND the user
  /// consents to the claim being returned
  ///
  /// ```json
  /// {
  ///   "formatted": "Wisteria House\n1 Acacia Ave\n Bredon\n Narthwich\nNorfolk",
  ///   "postal_code": "AB12 3CD"
  /// }
  /// ```
  ///
  /// NOTE: Support for this claim is currently under user research and
  /// evaluation
  final NhsAddressField address;

  /// A string containing the End User’s NHS Number – this is a 10 digit string
  /// {nhs_number}
  final String nhsNumber;

  /// These will only be returned where the user’s identity has been verified
  /// AND the [NhsScope.gpIntegrationCredentials] is requested AND the user
  /// consents to the claim being returned
  /// {gp_integration_credentials}
  ///
  /// NOTE: Support for this claim is currently under user research and
  /// evaluation
  final GpIntegrationCredentials gpIntegrationCredentials;

  /// An array of other NHS Numbers for which this user has some authority to
  /// access data – the value is a hint for use in user-presentation and not for
  /// sole use in access-control decisions
  /// {delegations}
  ///
  /// NOTE: The approach to supporting delegations is currently under user
  /// research and evaluation
  final List<String> delegations;

  /// End-User’s registered General Practice as held in NHS Personal
  /// Demographics Service.
  /// {gp_registration_details}
  ///
  /// This information will only be returned where the user’s identity has been
  /// verified AND the [NhsScope.gpRegistrationDetails] is requested AND the
  /// user consents to the claim being returned
  ///
  /// NOTE: Support for this claim is currently under user research and
  /// evaluation
  final GpRegistrationDetails gpRegistrationDetails;

  @override
  final NhsUserinfoError error;

  @override
  final String errorDescription;

  // Not USED
  @override
  String get errorUri => null;
}

class NhsAddressField {
  const NhsAddressField({
    @required this.formatted,
    @required this.postalCode,
  });

  factory NhsAddressField.fromJson(Map<String, dynamic> json) {
    return NhsAddressField(
      formatted: json['formatted'],
      postalCode: json['postal_code'],
    );
  }

  /// {formatted}
  ///
  /// The address will be returned as a formatted string, using newline
  /// characters to separate the lines. Where possible the format will conform
  /// to the following:
  ///   1. House Name on line
  ///   2. House Number/Thoroughfare
  ///   3. Locality
  ///   4. Post Town
  ///   5. County
  final String formatted;

  /// {postal_code}
  final String postalCode;
}

class GpIntegrationCredentials {
  const GpIntegrationCredentials({
    @required this.gpUserId,
    @required this.gpSystemId,
    @required this.gpLinkageKey,
    @required this.gpOdsCode,
  });

  factory GpIntegrationCredentials.fromJson(Map<String, dynamic> json) {
    return GpIntegrationCredentials(
      gpUserId: json['gp_user_id'],
      gpSystemId: json['gp_system_id'],
      gpLinkageKey: json['gp_linkage_key'],
      gpOdsCode: json['gp_ods_code'],
    );
  }

  // {gp_user_id}
  final String gpUserId;

  // {gp_system_id}
  final String gpSystemId;

  // {gp_linkage_key}
  final String gpLinkageKey;

  // {gp_ods_code}
  final String gpOdsCode;
}

class GpRegistrationDetails {
  const GpRegistrationDetails({
    @required this.gpOdsCode,
    @required this.practiceName,
    @required this.practiceAddress,
  });

  factory GpRegistrationDetails.fromJson(Map<String, dynamic> json) {
    return GpRegistrationDetails(
      gpOdsCode: json['gp_ods_code'],
      practiceName: json['practice_name'],
      practiceAddress: NhsAddressField.fromJson(json['practice_address']),
    );
  }

  // {gp_ods_code}
  final String gpOdsCode;

  // {practice_name}
  final String practiceName;

  // {practice_address}
  final NhsAddressField practiceAddress;
}
