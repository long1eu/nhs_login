import 'dart:async';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:nhs_login/src/nhs_client.dart';

class Sender {
  Sender({
    @required this.authenticationUri,
    @required this.callback,
    @required this.urlLauncher,
    this.port = 3000,
  });

  final Uri authenticationUri;
  final void Function(Map<String, String>) callback;

  void send() {
    final String state = authenticationUri.queryParameters['state'];

    _requestsByState[state] = Completer<Map<String, String>>();
    _startServer(port)
        .then((_) => urlLauncher(authenticationUri.toString()))
        .then((_) => _requestsByState[state].future)
        .then(callback);
  }

  final UrlLauncher urlLauncher;
  final int port;

  static final Map<int, Future<HttpServer>> _requestServers =
      <int, Future<HttpServer>>{};
  static final Map<String, Completer<Map<String, String>>> _requestsByState =
      <String, Completer<Map<String, String>>>{};

  static Future<void> _startServer(int port) async {
    return _requestServers[port] ??=
        (HttpServer.bind(InternetAddress.loopbackIPv4, port)
          // ignore: unawaited_futures
          ..then((HttpServer requestServer) async {
            requestServer.port;
            await for (HttpRequest request in requestServer) {
              print(request.requestedUri);
              request.response.statusCode = 200;
              request.response.headers.set('Content-type', 'text/html');
              request.response.writeln('<html lang="en">'
                  '<h1>You can now close this window</h1>'
                  '<script>window.close();</script>'
                  '</html>');
              await request.response.close();
              final Map<String, String> result =
                  request.requestedUri.queryParameters;

              if (!result.containsKey('state')) {
                continue;
              }
              final Completer<Map<String, String>> r =
                  _requestsByState.remove(result['state']);
              r.complete(result);
              if (_requestsByState.isEmpty) {
                for (Future<HttpServer> s in _requestServers.values) {
                  await (await s).close();
                }
                _requestServers.clear();
              }
            }

            await _requestServers.remove(port);
          }));
  }
}
