import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

void main() {
  final port = '8080';
  final host = 'http://0.0.0.0:$port';

  setUp(() async {
    await TestProcess.start(
      'dart',
      ['run', 'bin/webshot_api.dart'],
      environment: {'PORT': port},
    );
  });

  test('Root', () async {
    final response = await get(Uri.parse(host + '/'));
    expect(response.statusCode, 200);
  });

  test('Help', () async {
    final response = await get(Uri.parse(host + '/help'));
    expect(response.statusCode, 200);
  });
  test('Ss', () async {
    final response = await get(Uri.parse(
        host + '/ss?url=www.google.com?quality=80&delay=1000&format=png'));
    expect(response.statusCode, 200);
  });
}
