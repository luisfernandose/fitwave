import 'package:flutter/material.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  List<dynamic> asesorias = [{'fecha':'junio'}]; // Aquí irán los datos de la API

  @override
  void initState() {
    super.initState();
    fetchAsesorias();
  }

  void fetchAsesorias() async {
    // Lógica para obtener los datos de la API
    // final response = await http.get(Uri.parse('https://api.example.com/asesorias'));
    // if (response.statusCode == 200) {
    //   setState(() {
    //     asesorias = jsonDecode(response.body)['data'];
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Asesorías')),
      body: asesorias.isEmpty
          ? CircularProgressIndicator()
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2,
              ),
              itemCount: asesorias.length,
              itemBuilder: (context, index) {
                var asesoria = asesorias[index];
                return Card(
                  child: Column(
                    children: [
                      Text('Fecha: ${asesoria['fecha']}'),
                      Text('Desde: ${asesoria['desde']}'),
                      Text('Hasta: ${asesoria['hasta']}'),
                      Text('Puntos: ${asesoria['puntos']}'),
                      Text('%: ${asesoria['porcentaje']}'),
                      Text('Total: ${asesoria['total']}'),
                      Text('Sesiones: ${asesoria['sesiones']}'),
                      Text('Sesiones Vistas: ${asesoria['sesionesVistas']}'),
                      ElevatedButton(
                        onPressed: () {
                          // Lógica para mostrar las sesiones
                        },
                        child: Text('Sesiones'),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
