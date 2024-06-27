import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  String base64Image = '';
  int counter = 60;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    fetchQR();
    startTimer();
  }

  void fetchQR() async {
    // final response = await http.get(Uri.parse('https://api.example.com/qr'));
    // if (response.statusCode == 200) {
      setState(() {
        // base64Image = jsonDecode(response.body)['image'];
        base64Image = 'iVBORw0KGgoAAAANSUhEUgAAAzQAAAM0AQMAAABXvPU0AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAGUExURQAAAP///6XZn90AAAAJcEhZcwAADsMAAA7DAcdvqGQAAAL0SURBVHja7dtBbtwwDABA/kD//6V/4AJZr0VR2qSXFpAzPCwsmeTwSBhJnP8lDg6Hw+FwOBwOh8PhcDgcDofD4XA4HA6Hw+FwOL/CiRrtlfF6yndfycNTTikNOBwOh8PhbO30+1L/bnJXRf8peet+HA6Hw+FwNnb6BnGlHddNIXJejFhpwOFwOBwO52HOmPvePubgcDgcDofzy5yVmO/KxwoOh8PhcDgPc1bHqUlcy8jKWffjcDgcDoezq1OijcRf/MwNOBwOh8PhbO2s4qeew9M3weFwOBwOZ1fnwx85ZjbW/yKRj7H4ewgOh8PhcDh7OrnnIPaqMkAm4k6Zx+NwOBwOh7Ork7HjbjKw0woyT5GPjcPhcDgczhOcTHw9xdT4upvLesWUwuFwOBwOZ08nd2/rrSK3Key8uXzaQzgcDofD4WzmrEqnF+9OV1l8S3A4HA6Hw3mEk+tjWRV9aem11/HI6wuHw+FwOJzNnbi3jxgL+kYS49sz7yHT0tI4HA6Hw+Fs75TVIiLutMjH+W0R+2QcDofD4XC2dqb6eYBeeuV1omwpvYzD4XA4HM7GTs/tPTO7cvqLGMXG4XA4HA7nCc5Uf47sHHkPiXEKDofD4XA4j3Cu+7KCDF8iyjEPdUxPHA6Hw+FwHuJMpe+fvGTEPUq7jzEO0AkOh8PhcDj7O21x7M6Re5ZRxsaRMQ6Hw+FwOBs7pb5g09057SFTKw6Hw+FwOFs7kZsUtr8tx1jEYm4Oh8PhcDg7Oqvoubl+6JQHOMel5eRwOBwOh7O5EzXKzhH3d4pVDOtLH4XD4XA4HM7mTsuvelUZ5cLauKW0qSzXcjgcDofD2dj5Zqvo3WP8YlF2k/ZqHBwOh8PhcJ7qfIyVWFpxOBwOh8N5opMXimMcYJ5i1YXD4XA4HM7+zoo9x8hTfHjB4XA4HA7nMU6J9sqIO7e+zT373TwZh8PhcDicXZ1/GRwOh8PhcDgcDofD4XA4HA6Hw+FwOBwOh8PhcB7rnMcfLoB7KOVx97YAAAAASUVORK5CYII=';
        counter = 60;
      });
    // }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (counter > 0) {
          counter--;
        } else {
          fetchQR();
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Compartir QR')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          base64Image.isEmpty
              ? CircularProgressIndicator()
              : Image.memory(Base64Decoder().convert(base64Image)),
          SizedBox(height: 20),
          Text(
            '$counter',
            style: TextStyle(
              fontSize: 48,
              color: counter <= 5 ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
