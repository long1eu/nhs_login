import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:nhs_login/nhs_login.dart';
import 'package:nhs_login/src/models/nhs_token_response.dart';

void main() async {
  final NhsLogin nhsLogin = NhsLogin(
    urlLauncher: _runBrowser,
    host: 'auth.sandpit.signin.nhs.uk',
    redirectUri: 'http://${InternetAddress.loopbackIPv4.host}:3000',
    clientId: 'digital-health-passport',
    jwtSigner: jwtSigner,
  );

  final NhsAuthenticationResponse result = await nhsLogin.login(
    NhsAuthentication(
      scopes: [NhsScope.openId, NhsScope.profile],
      prompt: NhsPrompt.none,
      vectorOfTrust: P0_Cp_Cd | P5_Cp_Cd,
    ),
  );

  final NhsTokenResponse token = await nhsLogin.getToken(result);

  nhsLogin.getUser();

  print(token);
}

void _runBrowser(String url) {
  switch (Platform.operatingSystem) {
    case "linux":
      Process.run("x-www-browser", [url]);
      break;
    case "macos":
      Process.run("open", [url]);
      break;
    case "windows":
      Process.run("explorer", [url]);
      break;
    default:
      throw UnsupportedError(
          "Unsupported platform: ${Platform.operatingSystem}");
      break;
  }
}

Future<String> jwtSigner(String code) async {
  final Response response = await Client().get(
      'https://europe-west1-hackathon-passport-v2.cloudfunctions.net/signKey');

  if (response.statusCode != 200) {
    throw StateError('Could not get a valid JWT.');
  }

  return jsonDecode(response.body)['key'];
}
