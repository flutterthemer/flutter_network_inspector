Effortlessly monitor your app’s network calls with this simple and easy-to-use package for the [http](https://pub.dev/packages/http)! and [dio](https://pub.dev/packages/dio)! library.

## Features

* Monitor network calls within the app
* View all details in the Flutter UI itself.
* Turn on and off logging of all network info.

## Demo

<img src="https://raw.githubusercontent.com/flutterthemer/flutter_network_inspector/refs/heads/main/demo.gif" alt="App Screenshot" width="320" height="700">

## Getting started

Create a client for your network calls, which is an object of FNI Class.
Then use this client to do all network calls.
You can also use the network inspector UI to view all the info about the network calls.
The UI is fully compatible with your app's theme.

## Usage

```dart
  // Using Dio Client
  final dioClient = FNI.init(dio: Dio());
  // Enable logging
  FNI.setEnableLogging(false);
  // Use the client to do the calls
  var response = await dioClient.get(
    'https://jsonplaceholder.typicode.com/posts/1',
    options: Options(
      headers: {'Content-Type': 'application/json'},
    ),
    data: '{"title": "foo", "body": "bar", "userId": 1}',
  );

  // Using Http Client
  final httpClient = FNI.init(httpClient: http.Client());
  // Disable logging
  FNI.setEnableLogging(false);
  // Use the client to do the calls
  var response = await httpClient.post(
    Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
    headers: {'Content-Type': 'application/json'},
    body: '{"title": "foo", "body": "bar", "userId": 1}',
  );
```

To view the details of network calls, you can add the Flutter network inspector UI anywhere in your widget tree. 

```dart
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: const Text('Flutter Network Inspector'),
      ),
      body: const FNIHome(), // show all network activity, use it with your navigator too.
    );
  }
```