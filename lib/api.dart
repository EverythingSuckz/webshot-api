import 'dart:convert';
import 'browser.dart';
import 'screen_shot.dart';
import 'package:puppeteer/puppeteer.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_router/shelf_router.dart';

late Browser browser;

String helpMessage =
    "You can take screenshot for any website using this api, just pass in the necessary query parameter in the /ss endpoint."
    "\n\nAvailable parameters: (parms with '*' are optional)\n"
    "  - url: The url of the site for which you want to take the screenshot of (with url encoding).\n"
    "  - *mobile: If true, emulate mobile device. Default is false.\n"
    "  - *width: Width of the screenshot in pixels. Default is 1024.\n"
    "  - *height: Height of the screenshot in pixels. Default is 768.\n"
    "  - *fullPage: If true, take a screenshot of the full scrollable page. Default is false.\n"
    "  - *pdfScale: Scale of the webpage while generating PDF. Default is 1.\n"
    "  - *deviceScaleFactor: Device scale factor. Default is 1.\n"
    "  - *quality: Quality of the screenshot. Default is 80.\n"
    "  - *delay: The delay after which which the screenshot should be taken (in ms).\n"
    "  - *format: The format in which the screenshot will be returned, it should be one of [png/jpeg/pdf]. Default is png.\n"
    "  - *omitBackground: If true, don't include the background color in the screenshot. Default is false.\n"
    "\n\nExample: \n\n"
    "  http://localhost:8080/ss?url=www.google.com?quality=80&delay=1000&format=png";

class SSApi {
  Future<Router> get router async {
    final router = Router();
    browser = await initBrowser();
    router.get('/', (shelf.Request request) async {
      return shelf.Response.ok(
          json.encode({
            'status': 'ok',
            'message':
                'You can take screenshot for any website using this api, check /help endpoint for more info.'
          }),
          headers: {'content-type': 'application/json'});
    });

    router.get('/help', (shelf.Request request) async {
      return shelf.Response.ok(helpMessage, headers: {
        'content-type': 'text/plain',
      });
    });

    router.get('/ss', (shelf.Request request) async {
      // Get all the query parameters from the request
      late String contentType;
      final queryParams = request.url.queryParameters;

      String? url = queryParams['url'];
      final mobile =
          request.url.queryParameters['mobile']?.toLowerCase() == "true";
      final width = queryParams['width'] != null
          ? int.parse(queryParams['width']!)
          : null;
      final height = queryParams['height'] != null
          ? int.parse(queryParams['height']!)
          : null;
      final fullPage = queryParams['fullPage']?.toLowerCase() == 'true';
      final pdfScale = queryParams['pdfScale'] != null
          ? int.parse(queryParams['pdfScale']!)
          : 1;
      final deviceScaleFactor = queryParams['deviceScaleFactor'] != null
          ? double.parse(queryParams['deviceScaleFactor']!)
          : 1;
      final quality = queryParams['quality'] != null
          ? int.parse(queryParams['quality']!)
          : 80;
      final delay =
          queryParams['delay'] != null ? int.parse(queryParams['delay']!) : 0;
      final format = queryParams['format'];
      final omitBackground =
          queryParams['omitBackground']?.toLowerCase() == 'true';

      if (url == null || url.isEmpty) {
        return shelf.Response.notFound(json.encode(
            {'status': 'error', 'message': 'url parameter is required'}));
      }
      String parsedUrl =
          url.startsWith(RegExp(r"^https?:\/\/.\S+")) ? url : 'https://$url';
      parsedUrl = Uri.decodeComponent(parsedUrl);
      print("Processing $parsedUrl");
      contentType = format == 'pdf' ? 'application/pdf' : 'image/png';
      final Page page = await browser.newPage();
      try {
        var data = await takeScreenShot(page, parsedUrl,
            height: height,
            width: width,
            fullPage: fullPage,
            pdfScale: pdfScale,
            deviceScaleFactor: deviceScaleFactor,
            quality: quality,
            delay: delay,
            format: format,
            omitBackground: omitBackground,
            isMoble: mobile);
        return shelf.Response.ok(data, headers: {'Content-Type': contentType});
      } catch (e) {
        await page.close();
        print(e);
        return shelf.Response.ok(
            jsonEncode({'status': 'error', 'message': e.toString()}),
            headers: {'Content-Type': 'application/json'});
      }
    });

    return router;
  }
}
