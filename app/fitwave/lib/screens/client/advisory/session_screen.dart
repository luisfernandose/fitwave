import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart'; // Para usar TextInputFormatter

import '../models/session_data.dart';
import 'qr_scan_screen.dart'; // Importa tu pantalla de escaneo QR aquí

class SessionScreen extends StatefulWidget {
  final String idCoaching;
  const SessionScreen({required this.idCoaching, Key? key});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  List<SessionData> sessionLists = [];
  SessionData? activeSession;
  late String? token;
  bool isActive = true;
  late String? couchingId;
  int points = 0;
  TextEditingController pendingPointsController = TextEditingController();
  final Color primaryColor = Color.fromARGB(255, 111, 165, 167);
  final Color backgroundColor = Color.fromARGB(255, 248, 248, 248);

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadTokenAndFetchData();
  }

  Future<void> _loadTokenAndFetchData() async {
    await _loadToken();
    fetchData();
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
  }

  void fetchData() async {
    final response = await http.get(
      Uri.parse('https://fitwave.fit/api/FitApi/GetCustomerSessions'),
      headers: {
        'Authorization': token!,
        'CoachingId': widget.idCoaching,
      },
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body)['data'];
      var sessionListData = responseData['sessionLists'] as List;
      var activeSessionData = responseData['activeSession'];

      if (activeSessionData == null) {
        setState(() {
          isActive = false;
        });
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('idSession', activeSessionData['idSession']);
        setState(() {
          activeSession = SessionData.fromJson(activeSessionData);
          points = activeSession!.sessionPendingPoints.toInt();
          pendingPointsController.text =
              activeSession!.sessionPendingPoints.toStringAsFixed(0);
        });
      }

      setState(() {
        sessionLists =
            sessionListData.map((data) => SessionData.fromJson(data)).toList();
        // Ordenar sessionLists por sessionNumber
        sessionLists.sort((a, b) => a.sessionNumber.compareTo(b.sessionNumber));
      });
    } else {
      print(response.body);
      _showErrorDialog('Error ${response.statusCode}');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(
            'Hubo un problema, intenta de nuevo.\nDetalle: $message',
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(fontSize: 18),
              ),
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

  String formatDate(String date) {
    return date.split('T')[0]; // Elimina la parte de la hora de la fecha
  }

  Widget buildSessionCard(SessionData session) {
    return Card(
      color: backgroundColor,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Fecha: ',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: formatDate(session.sessionDate),
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Estado: ',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: session.status,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Puntos: ',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: session.sessionPoints
                        .toStringAsFixed(0)
                        .replaceAllMapped(
                            RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.'),
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Puntos aplicados: ',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: session.sessionPointsApplied
                        .toStringAsFixed(0)
                        .replaceAllMapped(
                            RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.'),
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Puntos pendientes: ',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: session.sessionPendingPoints
                        .toStringAsFixed(0)
                        .replaceAllMapped(
                            RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.'),
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sesiones'),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Sesión Activa',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          isActive
              ? Card(
                  color: backgroundColor,
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Puntos: ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: activeSession?.sessionPoints
                                              .toStringAsFixed(0)
                                              .replaceAllMapped(
                                                RegExp(r'\B(?=(\d{3})+(?!\d))'),
                                                (match) => '.',
                                              ),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Puntos Aplicados: ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: activeSession
                                              ?.sessionPointsApplied
                                              .toStringAsFixed(0)
                                              .replaceAllMapped(
                                                RegExp(r'\B(?=(\d{3})+(?!\d))'),
                                                (match) => '.',
                                              ),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'Puntos Pendientes',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Container(
                                    width: 150,
                                    child: TextFormField(
                                      controller: pendingPointsController,
                                      decoration: InputDecoration(
                                        labelText: '',
                                        labelStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 12),
                                        isDense: true,
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        ThousandsSeparatorInputFormatter(),
                                      ],
                                      onChanged: (value) {
                                        if (int.tryParse(
                                                value.replaceAll('.', '')) !=
                                            null) {
                                          int parsedValue = int.parse(
                                              value.replaceAll('.', ''));
                                          if (parsedValue <=
                                              activeSession!.sessionPoints) {
                                            points = parsedValue;
                                          } else {
                                            // Setear el valor máximo permitido si se superan los puntos
                                            pendingPointsController.text =
                                                activeSession!.sessionPoints
                                                    .toStringAsFixed(0)
                                                    .replaceAllMapped(
                                                        RegExp(
                                                            r'\B(?=(\d{3})+(?!\d))'),
                                                        (match) => '.');

                                            // Mostrar mensaje de alerta
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Advertencia'),
                                                  content: Text(
                                                    'Los puntos pendientes no pueden ser mayores que los puntos de sesión (${activeSession!.sessionPoints}). Se establecerá el valor máximo permitido automáticamente.',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: Text('OK'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        } else {
                                          // Handle invalid input
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Fecha: ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: formatDate(
                                              activeSession?.sessionDate ?? ''),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Estado: ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: activeSession?.status,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 17),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (pendingPointsController
                                          .text.isEmpty) {
                                        // Validación si el campo está vacío
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Error'),
                                              content: Text(
                                                'Debe ingresar los puntos pendientes antes de marcar la sesión.',
                                              ),
                                              actions: [
                                                TextButton(
                                                  child: Text('OK'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        // Continuar con la navegación si el campo no está vacío
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                QrScanScreen(points: points),
                                          ),
                                        ).then((_) {
                                          fetchData(); // Llama a fetchData al regresar
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                    ),
                                    child: Text(
                                      "Marcar Sesión",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Text(
                  'Asesoria Completada',
                  style: TextStyle(fontSize: 30),
                )),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Sesiones',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: sessionLists.isEmpty
                ? Center(
                    child: LoadingAnimationWidget.newtonCradle(
                      color: Colors.black,
                      size: 200,
                    ),
                  )
                : ListView.builder(
                    itemCount: sessionLists.length,
                    itemBuilder: (context, index) {
                      var session = sessionLists[index];
                      return buildSessionCard(session);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// Formateador personalizado para separar los miles
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.replaceAll('.', '');
    String formattedText = '';
    for (int i = 0; i < newText.length; i++) {
      if (i != 0 && (newText.length - i) % 3 == 0) {
        formattedText += '.';
      }
      formattedText += newText[i];
    }
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
