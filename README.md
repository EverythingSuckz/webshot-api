
# Webshot API

Yet another simple webshot API but written in dart and built using [Shelf](https://pub.dev/packages/shelf) library to generate images from url. This is really useful for link previews for blog shares in social media sites.

## Deploy your own instance
- ### Locally hosting 


#### Install Dart SDK.
Follow [this link](https://dart.dev/get-dart) to get started with Dart.
#### Clone the repository.

```sh
git clone https://www.github.com/EverythingSuckz/webshot-api
cd webshot-api
dart pub get
```

#### Running the webserver.

You can run the webapp with the [Dart SDK](https://dart.dev/get-dart) by executing this in the terminal:

```sh
dart run
```

or to specify a port:

```sh
dart bin/webshot_api.dart --port 8080
```

For generating a standalone executable file:

```
dart compile exe bin/server.dart -o server.exe
```

- ### Heroku
   - todo

**Note**: _This is my first dart project so, the code might be a bit messy._

### Credits
- [StaticallyIO's Screenshot API](https://github.com/staticallyio/screenshot)
- [ws-screenshot](https://github.com/elestio/ws-screenshot)
- [Akash Pattnaik](https://github.com/BLUE-DEVIL1134)
- [『Kyouin』](https://telegram.dog/HKyouma)