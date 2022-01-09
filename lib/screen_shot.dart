import 'dart:typed_data';
import 'package:puppeteer/puppeteer.dart' as pp;

Future<Uint8List?> takeScreenShot(
  pp.Page page,
  String url, {
  String? format,
  bool? isMoble,
  bool? fullPage,
  bool? omitBackground,
  num? pdfScale,
  num? deviceScaleFactor,
  int? delay,
  int? width,
  int? height,
  int? maxTimeOut,
  int? quality = 84,
}) async {
  int defaultWidth;
  int defaultHeight;
  bool hasTouch;

  format ??= "jpg";
  quality ??= 84;
  fullPage ??= false;
  isMoble ??= false;
  omitBackground ??= false;
  delay ??= 0;
  pdfScale ??= 1;
  deviceScaleFactor ??= 1;
  maxTimeOut ??= 30000; // 30 seconds

  if (isMoble) {
    await page.setUserAgent(
        'Mozilla/5.0 (Linux; Android 8.0; Pixel 2 Build/OPD3.170816.012) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Mobile Safari/537.36 Dart-Webshot-API/1.0.0');
    defaultWidth = 411;
    defaultHeight = 731;
    hasTouch = true;
  } else {
    await page.setUserAgent(
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36 Dart-Webshot-API/1.0.0');
    defaultWidth = 1280;
    defaultHeight = 960;
    hasTouch = false;
  }
  width ??= defaultWidth;
  height ??= defaultHeight;
  await page.setViewport(pp.DeviceViewport(
      width: width,
      height: height,
      hasTouch: hasTouch,
      isMobile: isMoble,
      deviceScaleFactor: deviceScaleFactor));
  await page.goto(url);
  // await autoScrol(page);
  // await page.waitForNavigation(
  //     wait: pp.Until.networkIdle, timeout: Duration(milliseconds: maxTimeOut));
  Uint8List? rawImage;
  await Future.delayed(Duration(milliseconds: delay));
  if (["png", "jpeg"].contains(format)) {
    final _format =
        format == "png" ? pp.ScreenshotFormat.png : pp.ScreenshotFormat.jpeg;
    rawImage = await page.screenshot(
        omitBackground: omitBackground,
        quality: quality,
        fullPage: fullPage,
        format: _format);
  } else {
    rawImage = await page.pdf(
        format: pp.PaperFormat.a4,
        printBackground: !omitBackground,
        landscape: false,
        scale: pdfScale);
  }
  await page.close();
  return rawImage;
}

// Thanks to elestio/ws-screenshot
// https://github.com/elestio/ws-screenshot/blob/master/API/shared.js#L239
Future<void> autoScrol(pp.Page page) async {
  int totalHeight = 0;
  do {
    await page.evaluate('window.scrollBy(0, 200)');
    await Future.delayed(Duration(milliseconds: 100));
    totalHeight += 200;
  } while (await page.evaluate('window.scrollY') >=
      totalHeight); // scroll down to bottom
}
