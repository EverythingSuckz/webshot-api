import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:webshot_api/api.dart';
import 'package:shelf_router/shelf_router.dart';

void main(List<String> args) async {
  final app = Router();
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final _handler = Pipeline().addMiddleware(logRequests()).addHandler(app);
  app.mount('/', await SSApi().router);
  int port;
  if (args.isNotEmpty && isValidPort(args.last) && args[0] == '--port' ||
      args[0] == '-p') {
    port = int.parse(args.last);
  } else {
    port = int.parse(Platform.environment['PORT'] ?? '8080');
  }
  final server = await serve(_handler, ip, port);
  print('Server listening on ${server.address.host}:${server.port}');

  // https://stackoverflow.com/a/64190688
  ProcessSignal.sigint.watch().listen((signal) async {
    print("Are you sure you want to exit? (y/n)");
    stdout.write(">> ");
    String? userIn = stdin.readLineSync();
    while (
        userIn != null && !userIn.startsWith("y") && !userIn.startsWith("n")) {
      print("Please enter 'y' or 'n'");
      stdout.write(">> ");
      userIn = stdin.readLineSync();
    }
    if (userIn != null && userIn.startsWith("y")) {
      await server.close(force: true);
      await browser.close();
      print("Server closed.");
      exit(0);
    }
  });
}

bool isValidPort(String? s) {
  if (s == null || s.isEmpty || s.length > 5 || s.trim() == '0') {
    return false;
  }
  return int.tryParse(s) != null;
}
