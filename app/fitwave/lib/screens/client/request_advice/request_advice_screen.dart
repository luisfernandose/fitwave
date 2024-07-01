import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

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
      } else {
        _showDialog('Error al enviar la solicitud, prueba nuevamente',
            error: response.statusCode);
      }
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
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
              ElevatedButton(
                onPressed: _isButtonEnabled ? _sendRequest : null,
                child: Text('Solicitar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: backgroundColor,
    );
  }
}
