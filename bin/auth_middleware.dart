import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

import 'auth_service.dart';

class AuthMiddleware {
  final AuthService authService;

  const AuthMiddleware(this.authService);

  Middleware get middleware => _authenticate;

  Handler _authenticate(Handler handler) {
    return (request) async {
      final authHeader = request.headers['Authorization'];

      if (authHeader == null) {
        return Response.unauthorized('Auth header is missing');
      }

      final token = authHeader.split('Bearer ').last;

      try {
        authService.validateToken(token);

        return handler(request);
      } on JWTInvalidException {
        return Response.unauthorized('Auth token is invalid');
      } on JWTExpiredException {
        return Response.unauthorized('Auth token is expired');
      }
    };
  }
}
