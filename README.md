Effortlessly monitor your app’s network calls with this simple and easy-to-use package for the http library!

## Features

* Monitor network calls within the app
* View all details in the Flutter UI itself.
* Turn on and off whenever you want.

## Demo

<img src="https://raw.githubusercontent.com/flutterthemer/flutter_network_inspector/refs/heads/main/demo.gif" alt="App Screenshot" width="320" height="700">

## Getting started

Create a client for your network calls, which is an object of FNIClient.
Then use this client to do all network calls.
You can also use the network inspector UI to view all the info about the network calls.
The UI is fully compatible with your app's theme.

## Usage

```dart
 final client = FNICLient();

 final postResponse = await client.post(
    Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    headers: {'Content-Type': 'application/json'},
    body: '{"title": "foo", "body": "bar", "userId": 1}',
 );
 doLog('Response: ${postResponse.body}');
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
      body: const FNIHome(),
    );
  }
```