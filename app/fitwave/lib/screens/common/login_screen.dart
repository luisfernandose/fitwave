import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();
  var emailCont = TextEditingController(text: '');
  var passwordCont = TextEditingController(text: '');
  var emailFocus = FocusNode();
  var passwordFocus = FocusNode();
  bool rememberPassword = false;
  bool isLoading = false;
  final String secretKey =
      "aB2zL9!cQ8*dE7+fX6hY5^iZ4&jK3(mN1oP0pR)qS[wT]uV{W}xUy@Z";
  String? role;
  String? userName;
  String? userId;

  Future<String> getDeviceId() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final allInfo = deviceInfo.data;
    return allInfo['id'] ?? 'Unknown Device ID';
  }

  Future<void> signIn() async {
    setState(() {
      isLoading = true;
    });

    String deviceId = await getDeviceId();
    var requestBody = jsonEncode(<String, String>{
      'user': emailCont.text,
      'password': passwordCont.text,
      'deviseId': deviceId,
      'secretkey': secretKey,
    });

    print("Request Body: $requestBody");

    final response = await http.post(
      Uri.parse('https://fitwave.bufalocargo.com/api/Security/ApiLogin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: requestBody,
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);

      // Check if 'rol' is null in the response
      if (responseData['data']['rol'] == null) {
        _showResponseDialog('Error', 'Ocurrió un error. Intenta de nuevo');
        return;
      }

      setState(() {
        role = responseData['data']['rol'];
        userName = responseData['data']['user']['names'];
        userId = responseData['data']['user']['id'];
      });

      // Save token in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', responseData['data']['token']);
      await prefs.setString('userId', responseData['data']['user']['id']);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(userName: userName!, role: role!),
        ),
      );
    } else {
      _showResponseDialog('Login failed', 'Error: ${response.body}',
          statusCode: response.statusCode);
    }
  }

  void _showResponseDialog(String title, String message, {int? statusCode}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$title (${statusCode ?? 'Desconocido'})'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color.fromARGB(255, 111, 165, 167);
    final Color backgroundColor = Color.fromARGB(255, 248, 248, 248);
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondo.jpg', // Ruta de la imagen de fondo local
              fit: BoxFit.cover,
            ),
          ),
          // Contenido en una caja blanca
          Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/FitWaveLogo.png',
                          height: 100, width: 100),
                      const SizedBox(height: 10),
                      const Text(
                        'Inicia sesión para continuar',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      TextFormField(
                        controller: emailCont,
                        decoration: InputDecoration(
                          label: const Text('Correo / Usuario'),
                          hintText: 'Correo / Usuario',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      TextFormField(
                        controller: passwordCont,
                        obscureText: true,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese tu clave';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Contraseña'),
                          hintText: 'Ingresa tu contraseña',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              TextEditingController _emailController =
                                  TextEditingController();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Cambiar contraseña'),
                                    content: TextField(
                                      controller: _emailController,
                                      decoration: const InputDecoration(
                                        hintText: 'Correo',
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancelar'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          String enteredEmail =
                                              _emailController.text;
                                          print(
                                              'Correo Electrónico Ingresado: $enteredEmail');
                                        },
                                        child: const Text('Enviar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text(
                              'Olvidaste tu contraseña?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, // Color de fondo
                            backgroundColor: primaryColor, // Color del texto
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              await signIn();
                            }
                          },
                          child: isLoading
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text('Iniciar Sesión'),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
