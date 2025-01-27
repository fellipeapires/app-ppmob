// ignore_for_file: deprecated_member_use

import 'package:app_ppmob/src/screen/documentos_screen/condutor_screen.dart';
import 'package:app_ppmob/src/shared/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeReaderScreen extends StatefulWidget {
  const QRCodeReaderScreen({super.key});

  @override
  QRCodeReaderScreenState createState() => QRCodeReaderScreenState();
}

class QRCodeReaderScreenState extends State<QRCodeReaderScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isFlash = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (defaultTargetPlatform == TargetPlatform.android) {
      controller?.pauseCamera();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      controller?.resumeCamera();
    }
  }

  Widget bottomNavigationBar(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BottomAppBar(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      height: size.height * 0.111,
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            tooltip: (isFlash ? 'Desligar a Lanterna' : 'Ligar a Lanterna'),
            splashColor: Theme.of(context).colorScheme.secondary,
            color: Theme.of(context).colorScheme.primary,
            iconSize: 30.0,
            icon: FaIcon(
              isFlash ? FontAwesomeIcons.solidLightbulb : FontAwesomeIcons.lightbulb,
              color: const Color(0xFF002358),
            ),
            onPressed: () {
              controller?.toggleFlash();
              isFlash = !isFlash;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNavigationBar(context),
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text(
          TitleScreen.leitorQrCodeCnh,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1C7ED6),
            height: 0.5,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      final qrCodeData = scanData.code;

      if (qrCodeData != null) {
        Navigator.of(context).pop(qrCodeData);
        controller.dispose();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CondutorScreen(
              qrCodeData: qrCodeData,
            ),
          ),
        );
      }
    });
  }
}
