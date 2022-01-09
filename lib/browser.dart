import 'package:puppeteer/puppeteer.dart' as pp;

Future<pp.Browser> initBrowser() async {
  final browser = await pp.puppeteer.launch(ignoreHttpsErrors: true, args: [
    "--mute-audio",
    "--no-sandbox",
    '--hide-scrollbars',
    "--disable-breakpad",
    "--disable-extensions",
    "--disable-dev-shm-usage",
    "--metrics-recording-only",
    '--force-color-profile=srgb',
    '--font-render-hinting=none',
    "--disable-renderer-backgrounding",
    "--disable-ipc-flooding-protection",
    "--disable-background-timer-throttling",
    "--disable-backgrounding-occluded-windows",
    "--disable-component-extensions-with-background-pages",
    "--disable-features=TranslateUI,BlinkGenPropertyTrees",
    "--enable-features=NetworkService,NetworkServiceInProcess",
  ]);
  browser.ignoreHttpsErrors;
  return browser;
}
