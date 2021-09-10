import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:read_barcode/read_barcode.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Barcode Reader Demo',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final barcodeReader = BarcodeReader();
  String? code;

  @override
  void initState() {
    setState(() {
      code = barcodeReader.keycode;
    });
    super.initState();
  }

  void _listener() {
    setState(() {
      code = barcodeReader.keycode!;
    });
  }

  @override
  Widget build(BuildContext context) {
    barcodeReader.addListener(_listener);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Barcode Reader Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                  'Scan the barcode, scanned code will be displayed below'),
            ),
            Text(
              code!,
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    barcodeReader.removeListener(_listener);
    super.dispose();
  }
}
