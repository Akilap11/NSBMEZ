import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner/qr_scanner.dart';

import 'qr_results_screen.dart';

const bgColor = Color.fromARGB(255, 255, 255, 255);

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

bool isScanComplete = false;

void closeScreen() {
  isScanComplete = true;
}

class _QRScannerState extends State<QRScanner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text("QR Scanner",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 0, 0, 0),
              letterSpacing: 1,
            )),
      ),
      body: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          child: Column(children: [
            Expanded(
                child: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Plese scan the QR code in the area",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                          letterSpacing: 1,
                        )),
                    SizedBox(height: 16),
                    Text("Scanning will start automatically",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(222, 0, 0, 0),
                        )),
                  ]),
            )),
            Expanded(
                flex: 4,
                child: Container(
                  child: MobileScanner(onDetect: (capture) {
                    if (!isScanComplete) {
                      closeScreen();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResultsScreen(
                                    closeScreen: closeScreen,
                                    Code: null,
                                  )));
                    }
                  }),
                )),
            Expanded(
                child: Container(
              alignment: Alignment.center,
              child: Text("Add text",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 0, 0, 0),
                    letterSpacing: 1,
                  )),
            )),
          ])),
    );
  }
}