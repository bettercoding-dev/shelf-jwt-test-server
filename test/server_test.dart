import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:test/test.dart';

final port = '8080';
final host = 'http://0.0.0.0:$port';

void main() {
  late Process p;

  setUp(() async {
    p = await Process.start(
      'dart',
      ['run', 'bin/server.dart'],
      environment: {'PORT': port},
    );
    // Wait for server to start and print to stdout.
    await p.stdout.first;
  });

  tearDown(() => p.kill());

  test('Root unauthenticated', () async {
    final response = await get(Uri.parse('$host/'));
    expect(response.statusCode, 401);
  });

  test('404', () async {
    final response = await get(Uri.parse('$host/foobar'));
    expect(response.statusCode, 404);
  });

  test('Root authenticated', () async {
    final body = await _login();

    final token = body['token'];

    expect(token, isNotNull);
    expect(body['refreshToken'], isNotNull);

    final response = await get(Uri.parse('$host/'),
        headers: {'Authorization': 'Bearer $token'});

    expect(response.statusCode, 200);
  });
}

Future<Map<String, dynamic>> _login() async {
  final response = await post(
    Uri.parse('$host/login'),
    body: jsonEncode(
      {'username': 'testuser'},
    ),
  );

  expect(response.statusCode, 200);
  final rawBody = response.body;
  final body = jsonDecode(rawBody);
  return body;
}
