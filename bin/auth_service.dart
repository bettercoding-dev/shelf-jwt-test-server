import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class AuthService {
  static const _secret = 'unsecret_secret';

  String generateToken(String user) {
    final jwt = JWT({'user': user});
    final token = jwt.sign(SecretKey(_secret), expiresIn: Duration(seconds: 15));
    return token;
  }

  String generateRefreshToken(String user) {
    final jwt = JWT({'user': user});
    final token = jwt.sign(SecretKey(_secret), expiresIn: Duration(minutes: 1));
    return token;
  }

  Map<String, dynamic> validateToken(String token) {
    final jwt = JWT.verify(token, SecretKey(_secret));
    return jwt.payload;
  }
}
