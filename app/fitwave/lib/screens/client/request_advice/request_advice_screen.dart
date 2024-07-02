import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/coaching_request_data.dart';

class RequestAdviceScreen extends StatefulWidget {
  @override
  _RequestAdviceScreenState createState() => _RequestAdviceScreenState();
}

class _RequestAdviceScreenState extends State<RequestAdviceScreen> {
  final TextEditingController _pointsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? token;
  String? userId;
  bool _isButtonEnabled = false;
  List<CoachingRequest> coachingRequests = [];

  @override
  void initState() {
    super.initState();
    _loadToken();
    _pointsController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _pointsController.removeListener(_validateForm);
    _pointsController.dispose();
    super.dispose();
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userId = prefs.getString('userId');
      // userId = 'f92ed681-c558-4bcf-9323-7e7f010b3331';
    });
    if (token != null && userId != null) {
      _fetchCoachingRequests();
    }
  }

  void _validateForm() {
    final text = _pointsController.text;
    if (text.isNotEmpty &&
        int.tryParse(text.replaceAll(',', '')) != null &&
        int.parse(text.replaceAll(',', '')) >= 1) {
      setState(() {
        _isButtonEnabled = true;
      });
    } else {
      setState(() {
        _isButtonEnabled = false;
      });
    }
  }

  Future<void> _sendRequest() async {
    if (_formKey.currentState!.validate()) {
      final int pointsRequested =
          int.parse(_pointsController.text.replaceAll(',', ''));
      final response = await http.post(
        Uri.parse(
            'https://fitwave.bufalocargo.com/api/FitApi/PlaceCoachingRequest'),
        headers: <String, String>{
          'Authorization': token!,
          'CustomerId': userId!,
          'PointsRequested': pointsRequested.toString(),
        },
      );

      if (response.statusCode == 200) {
        _showDialog('Solicitud enviada con éxito');
        _fetchCoachingRequests();
      } else {
        _showDialog('Error al enviar la solicitud, prueba nuevamente',
            error: response.statusCode);
      }
    }
  }

  Future<void> _fetchCoachingRequests() async {
    final response = await http.get(
      Uri.parse(
          'https://fitwave.bufalocargo.com/api/FitApi/GetAllCoachingRequest'),
      headers: <String, String>{
        'Authorization': token!,
        'CustomerId': userId!,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      // Verifica si jsonResponse es un objeto y contiene una lista de solicitudes
      if ((jsonResponse['data'] as List).isNotEmpty) {
        List<dynamic> jsonList = jsonResponse['data'];
        setState(() {
          coachingRequests =
              jsonList.map((json) => CoachingRequest.fromJson(json)).toList();
        });
      } else {
        _showDialog(
            'La respuesta del servidor no contiene una lista válida de solicitudes de asesoría');
      }
    } else {
      _showDialog(
          'Error al obtener las solicitudes de asesoría, prueba nuevamente',
          error: response.statusCode);
    }
  }

  void _showDialog(String message, {int? error}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: error == null ? Text('Información') : Text('Error $error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String? _validatePoints(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingrese los puntos solicitados';
    }
    if (int.tryParse(value.replaceAll(',', '')) == null) {
      return 'Por favor, ingrese un número válido';
    }
    if (int.parse(value.replaceAll(',', '')) < 1) {
      return 'El número debe ser mayor o igual a 1';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color.fromARGB(255, 111, 165, 167);
    final Color backgroundColor = Color.fromARGB(255, 248, 248, 248);

    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitar Asesoría'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _pointsController,
                    decoration: InputDecoration(
                      labelText: 'Puntos Solicitados',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      // Formateador para separar los números por miles
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final text = newValue.text.replaceAll(',', '');
                        final number = int.tryParse(text);
                        if (number != null) {
                          final formattedNumber =
                              NumberFormat('#,###').format(number);
                          return newValue.copyWith(
                            text: formattedNumber,
                            selection: TextSelection.collapsed(
                                offset: formattedNumber.length),
                          );
                        }
                        return newValue;
                      }),
                    ],
                    validator: _validatePoints,
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity, // Aumentar el tamaño horizontal
                    child: ElevatedButton(
                      onPressed: _isButtonEnabled ? _sendRequest : null,
                      child: Text('Solicitar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Sesiones',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: coachingRequests.length,
                itemBuilder: (context, index) {
                  final request = coachingRequests[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      tileColor: backgroundColor,
                      title: Text(
                          'Solicitud #${request.requestNumber} - ${request.status}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Puntos Solicitados: ${request.pointsRequested}'),
                          Text('Puntos Aprobados: ${request.pointsApproved}'),
                          Text(
                              'Fecha de Inicio: ${DateFormat('yyyy-MM-dd').format(request.startDate!)}'),
                          Text(
                              'Fecha de Fin: ${DateFormat('yyyy-MM-dd').format(request.endDate!)}'),
                        ],
                      ),
                      onTap: () {
                        // Acción al tocar la tarjeta
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
