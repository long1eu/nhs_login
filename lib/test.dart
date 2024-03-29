import 'dart:convert';
import 'dart:io';

import 'package:nhs_login/nhs_login.dart';

void main() async {
  final NhsClient nhsLogin = NhsClient(
    urlLauncher: _runBrowser,
    host: 'auth.sandpit.signin.nhs.uk',
    redirectUri:
        'https://europe-west1-hackathon-passport-v2.cloudfunctions.net/getAccessToken',
    clientId: 'digital-health-passport',
  );

  print(jsonEncode(NhsAuthentication.fromValues(
    clientId: nhsLogin.clientId,
    host: nhsLogin.host,
    redirectUri: nhsLogin.redirectUri,
    scopes: [
      NhsScope.openId,
      NhsScope.profile,
    ],
    prompt: NhsPrompt.none,
    vectorOfTrust: P0_Cp_Cd,
  ).json));

  /*
  final NhsLoginResult result = await nhsLogin.login(
    NhsAuthentication.fromValues(
      scopes: [
        NhsScope.openId,
        NhsScope.profile,
      ],
      prompt: NhsPrompt.none,
      vectorOfTrust: P0_Cp_Cd,
    ),
  );

  if (result.authentication.isError) {
    return;
  }

  print(result);
  */
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
