import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:nhs_login/src/models/authentication/nhs_authentication_error.dart';
import 'package:nhs_login/src/models/authentication/nhs_authentication_response.dart';
import 'package:nhs_login/src/models/nhs_token_response.dart';
import 'package:nhs_login/src/models/userinfo/nhs_userinfo.dart';
import 'package:nhs_login/src/nhs_authentication.dart';
import 'package:nhs_login/src/nhs_token_request.dart';
import 'package:nhs_login/src/util/sender.dart';
import 'package:user_preferences/user_preferences.dart';

/// Signature that should open the url into an user agent so that the End User
/// can interact with the NHS Servers
typedef UrlLauncher = void Function(String url);

/// Signature for a method that must return a valid signed JWT for the given
/// [code]
typedef JwtSigner = Future<String> Function(String code);

class NhsClient {
  const NhsClient({
    @required this.urlLauncher,
    @required this.jwtSigner,
    @required this.host,
    @required this.redirectUri,
    @required this.clientId,
  });

  static void init() async {
    await UserPreferences.init(Directory('${Directory.current.path}/build')
          ..createSync(recursive: true))
        .then((_) => _initialized = true);
  }

  static bool _initialized = false;

  /// Function that should open the url into an user agent so that the End User
  /// can interact with the NHS Server
  final UrlLauncher urlLauncher;

  /// Function what returns a valid sign JWT for the given
  /// [NhsAuthenticationResponse.code]
  final JwtSigner jwtSigner;

  /// The host of the NHS Server
  final String host;

  /// OAuth 2.0 Client Identifier
  ///
  /// This is a static identifier previously provided by the NHS login Partner
  /// Onboarding team
  final String clientId;

  /// Redirection URI to which the response will be sent.
  ///
  /// This URI MUST exactly match one of the Redirection URI values for the
  /// Client pre-registered at the OpenID Provider. When using this flow,
  /// the Redirection URI MUST NOT use the http scheme. The Redirection URI MAY
  /// use an alternate scheme, such as one that is intended to identify a
  /// callback into a native application
  final String redirectUri;

  Future<NhsAuthenticationResponse> login(
      NhsAuthentication authentication) async {
    if (!_initialized) await init();

    final Completer<NhsAuthenticationResponse> completer = Completer();
    authentication = authentication.mergeWith(this);

    Sender(
      authenticationUri: authentication.uri,
      urlLauncher: urlLauncher,
      callback: (Map<String, String> response) {
        final NhsAuthenticationResponse authenticationResponse =
            NhsAuthenticationResponse(
          state: response['state'],
          code: response['code'],
          error: NhsAuthenticationError.forName(response['error']),
          errorDescription: response['errorDescription'],
          errorUri: response['errorUri'],
          other: Map.from(response)
            ..remove('state')
            ..remove('code')
            ..remove('error')
            ..remove('errorDescription')
            ..remove('errorUri'),
        );

        completer.complete(authenticationResponse);
      },
    ).send();

    return completer.future;
  }

  Future<NhsTokenResponse> getToken(
      NhsAuthenticationResponse authResponse) async {
    if (!_initialized) await init();
    assert(!authResponse.isError);

    final String jwt = await jwtSigner(authResponse.code);

    final NhsTokenRequest tokenRequest = NhsTokenRequest(
      host: host,
      code: authResponse.code,
      redirectUri: redirectUri,
      clientId: clientId,
      clientAssertion: jwt,
    );

    String object = jsonEncode(tokenRequest.params);
    object = Uri.encodeQueryComponent(object);
    final List<int> data = utf8.encode(object);

    final HttpClientRequest request =
        await HttpClient().post(host, 443, 'token');

    request.headers.add('content-type', 'application/x-www-form-urlencoded');
    request.add(data);

    final HttpClientResponse response = await request.close();
    final String body =
        (await response.transform(utf8.decoder).toList()).join();

    if (response.statusCode == 200) {
      final NhsTokenResponse tokenResponse =
          await NhsTokenResponse.fromJson(jsonDecode(body));

      tokenResponse.accessToken;
      return tokenResponse;
    } else {
      throw StateError(
          'Coundn\'t get a valid token. Got error: (${response.statusCode}): '
          '$body');
    }
  }

  Future<NhsUserinfo> getUser([String accessToken]) async {
    if (!_initialized) await init();
    accessToken ??= UserPreferences.instance.getString('access_token');

    if (accessToken == null) {
      throw StateError('The user is not logged in.');
    }

    final HttpClientRequest request =
        await HttpClient().get(host, 443, 'userinfo');
    request.headers.add('Authorization', 'Bearer $accessToken');

    final HttpClientResponse response = await request.close();

    final String body =
        (await response.transform(utf8.decoder).toList()).join();

    if (response.statusCode == 200) {
      return NhsUserinfo.fromJson(jsonDecode(body));
    } else {
      throw StateError(
          'Coundn\'t get a the user. Got error: (${response.statusCode}): '
          '$body');
    }
  }
}

/*
    final List<int> data = utf8.encode(object);

    final HttpClientRequest request = await HttpClient()
        .postUrl(Uri(scheme: 'https', host: host, path: 'token'));

    print(request.uri);

    request.headers
      ..add('accept', 'application/json')
      ..add('content-type', 'application/x-www-form-urlencoded')
      ..add('content-length', data.length);

    print(request.headers);
    request.write(object);

    final HttpClientResponse response = await request.close();
    final String body =
        (await response.transform(utf8.decoder).toList()).join();

    print(body);
    print(response.headers);
    print(response.statusCode);

    return body;
*/

/*
    String object = jsonEncode(tokenRequest.params);
    object = Uri.encodeQueryComponent(object);
    final List<int> data = utf8.encode(object);

    final Response response = await Client().post(
      Uri(scheme: 'https', host: host, path: 'token'),
      headers: <String, String>{
        'accept': 'application/json',
        'content-type': 'application/x-www-form-urlencoded',
        'content-length': data.length.toString(),
      },
      body: data,
    );

    print(response.body);
    return response.body;
*/
