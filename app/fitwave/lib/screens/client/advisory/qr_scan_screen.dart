import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QrScanScreen extends StatefulWidget {
  final int points;
  const QrScanScreen({required this.points, super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  String? _qrInfo = 'Scan a QR/Bar code';
  bool _camState = false;

  _qrCallback(String? code) async {
    setState(() {
      _camState = false;
      _qrInfo = code;
    });

    if (_qrInfo != null) {
      await _sendSessionViewRequest();
    }
  }

  _scanCode() {
    setState(() {
      _camState = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _scanCode();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _sendSessionViewRequest() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? idSession = prefs.getString('idSession');
      String? token = prefs.getString('token');
      String url = 'https://fitwave.bufalocargo.com/api/FitApi/SetSessionView';

      if (idSession != null && token != null) {
        Map<String, String> headers = {
          'Authorization': token,
          'QrId': _qrInfo!,
          'PointsApplied': widget.points.toString(),
          'idSession': idSession
        };

        final response = await http.post(Uri.parse(url), headers: headers);

        if (response.statusCode == 200) {
          var responseData = jsonDecode(response.body);
          var responseCode = responseData['response_code'];
          var message = responseData['message'];
          if (responseCode == 1) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Registro Exitoso'),
                  content: Text(message),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error en el Registro'),
                  content: Text(message),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        } else {
          print('Error en la solicitud: ${response.statusCode}');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error en la solicitud'),
                content:
                    Text('Hubo un problema al intentar enviar la solicitud.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        print('No se encontró idSession o token en SharedPreferences.');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error en la Autenticación'),
              content: Text(
                  'No se pudo obtener la información necesaria para enviar la solicitud.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error al enviar la solicitud: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'Hubo un error inesperado al intentar enviar la solicitud.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color.fromARGB(255, 111, 165, 167);
    final Color backgroundColor = Color.fromARGB(255, 248, 248, 248);
    return Scaffold(
        appBar: AppBar(
          title: Text('QR Scanner'),
          backgroundColor: primaryColor,
        ),
        backgroundColor: backgroundColor,
        body: _camState
            ? Center(
                child: SizedBox(
                  height: 1000,
                  width: 500,
                  child: QRBarScannerCamera(
                    onError: (context, error) => Text(
                      error.toString(),
                      style: TextStyle(color: Colors.red),
                    ),
                    qrCodeCallback: (code) {
                      _qrCallback(code);
                    },
                  ),
                ),
              )
            : Center(
                child: LoadingAnimationWidget.newtonCradle(
                  color: Colors.black,
                  size: 200,
                ),
              ));
  }
}
