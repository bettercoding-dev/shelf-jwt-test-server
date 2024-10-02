import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'auth_middleware.dart';
import 'auth_router.dart';
import 'auth_service.dart';

final _authService = AuthService();

// Configure routes.
final _router = Router()
  ..mount('/', AuthRouter(_authService).router.call)
  ..get('/time', _timeHandler);

Handler get _timeHandler => Pipeline()
    .addMiddleware(AuthMiddleware(_authService).middleware)
    .addHandler(
      (_) => Response.ok(
        headers: {'Content-Type': 'Application/JSON'},
        jsonEncode(
          {
            'time': DateTime.now().toIso8601String(),
          },
        ),
      ),
    );

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler =
      Pipeline().addMiddleware(logRequests()).addHandler(_router.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
