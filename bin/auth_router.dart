import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'auth_service.dart';

class AuthRouter {
  final AuthService authService;

  const AuthRouter(this.authService);

  Router get router {
    final router = Router();

    router.post('/login', _loginHandler);
    router.post('/refresh', _refreshHandler);

    return router;
  }

  Future<Response> _loginHandler(Request request) async {
    try {
      final rawContent = await request.readAsString();
      final content = jsonDecode(rawContent);

      final username = content['username'];
      return _issueTokens(username);
    } catch (error, trace) {
      print('could not login error: $error, stackTrace: $trace');
      return Response.badRequest(
          headers: {'Content-Type': 'Application/JSON'},
          body: jsonEncode({'message': 'Invalid request.'}));
    }
  }

  Future<Response> _refreshHandler(Request request) async {
    try {
      final rawContent = await request.readAsString();
      final content = jsonDecode(rawContent);

      final refreshToken = content['token'];
      final payload = authService.validateToken(refreshToken);

      final user = payload['user'];
      return _issueTokens(user);
    } catch (error, trace) {
      print('could not login error: $error, stackTrace: $trace');
      return Response.badRequest(
          headers: {'Content-Type': 'Application/JSON'},
          body: jsonEncode({'message': 'Invalid request.'}));
    }
  }

  Response _issueTokens(String username) {
    final token = authService.generateToken(username);
    final refreshToken = authService.generateRefreshToken(username);

    return Response.ok(
      headers: {'Content-Type': 'Application/JSON'},
      jsonEncode(
        {
          'token': token,
          'refreshToken': refreshToken,
        },
      ),
    );
  }
}
