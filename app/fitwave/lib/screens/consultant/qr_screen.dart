import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  int counter = 60;
  Timer? timer;
  String base64Image = '';
  late String? token;
  late String? userId;
  bool isQRready = false;

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchQR();
  }

  Future<void> _loadTokenAndFetchQR() async {
    await _loadToken();
    fetchQR();
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userId = prefs.getString('userId');
    });
  }

  void fetchQR() async {
    final response = await http.get(
        Uri.parse('https://fitwave.fit/api/FitApi/GetAssesorQR'),
        headers: {
          'Authorization': '$token',
          'Id': userId!,
        });
    print(response.request);

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      setState(() {
        base64Image = responseData['data'];
        isQRready = true;
      });
    } else {
      _showAlertDialog('Error ${response.statusCode}',
          'Hubo un problema, intenta de nuevo', true);
    }
  }

  void _showAlertDialog(String title, String content, bool isError) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                if (isError) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pop();
                  fetchQR();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color.fromARGB(255, 111, 165, 167);
    final Color backgroundColor = Color.fromARGB(255, 248, 248, 248);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compartir QR'),
        backgroundColor: primaryColor,
      ),
      backgroundColor: backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          base64Image.isEmpty
              ? Center(child: const CircularProgressIndicator())
              : Image.memory(Base64Decoder().convert(base64Image)),
          const SizedBox(height: 20),
          isQRready
              ? TimerCountdown(
                  format: CountDownTimerFormat.secondsOnly,
                  timeTextStyle: TextStyle(fontSize: 50),
                  endTime: DateTime.now().add(
                    Duration(
                      days: 0,
                      hours: 0,
                      minutes: 1,
                      seconds: 0,
                    ),
                  ),
                  onEnd: () {
                    setState(() {
                      isQRready = false;
                    });
                    _showAlertDialog(
                        'Se venció el tiempo', 'Se generará otro QR', false);
                  },
                )
              : Center(child: const CircularProgressIndicator()),
        ],
      ),
    );
  }
}
