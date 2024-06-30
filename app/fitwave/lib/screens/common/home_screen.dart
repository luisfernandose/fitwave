import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../client/session_screen.dart';
import '../consultant/qr_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final String role;

  HomeScreen({required this.userName, required this.role});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? token;
  String? userId;

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userId = prefs.getString('userId');
      print('el token es: $token');
    });
  }

  final List<Map<String, String>> exercises = [
    {
      "name": "Push Ups",
      "image":
          "https://st4.depositphotos.com/12982378/23309/i/450/depositphotos_233093594-stock-photo-racial-man-doing-push-ups.jpg"
    },
    {
      "name": "Squats",
      "image":
          "https://st4.depositphotos.com/12985790/22701/i/450/depositphotos_227010956-stock-photo-focused-sportswoman-doing-squats-fitness.jpg"
    },
    {
      "name": "Lunges",
      "image":
          "https://st4.depositphotos.com/14803258/19880/i/450/depositphotos_198807916-stock-photo-side-view-handsome-adult-sportsman.jpg"
    },
    {
      "name": "Planks",
      "image":
          "https://www.shutterstock.com/image-photo/strong-beautiful-fitness-girl-athletic-260nw-1497529061.jpg"
    },
    {
      "name": "Jumping Jacks",
      "image": "https://i.blogs.es/45b092/jumpingjack/1366_2000.jpeg"
    }
  ];

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  void logout(BuildContext context) {
    // Aquí iría la lógica para cerrar sesión, como limpiar tokens, reiniciar el estado, etc.

    // Navegar de vuelta a la pantalla de inicio de sesión
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) =>
              LoginScreen()), // Reemplaza con tu pantalla de inicio de sesión
      (route) => false, // Elimina todas las rutas restantes en la pila
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerItems = [
      DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
            ),
            SizedBox(height: 10),
            Text(
              widget.userName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            Text(
              widget.role,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      ListTile(
        leading: Icon(Icons.home),
        title: Text('Inicio'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      if (widget.role == 'Asesor') ...[
        ListTile(
          leading: Icon(Icons.qr_code),
          title: Text('QR'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => QrScreen()));
          },
        ),
        ListTile(
          leading: Icon(Icons.info),
          title: Text('Información'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ] else if (widget.role == 'Cliente') ...[
        ListTile(
          leading: Icon(Icons.support),
          title: Text('Asesorías'),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SessionScreen()));
          },
        ),
        ListTile(
          leading: Icon(Icons.request_page),
          title: Text('Solicitud'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
      ListTile(
        leading: Icon(Icons.person),
        title: Text('Perfil'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text('Configuración'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading: Icon(Icons.logout),
        title: Text('Cerrar sesión'),
        onTap: () {
          logout(
              context); // Llama al método logout al hacer tap en Cerrar sesión
        },
      ),
    ];

    List<BottomNavigationBarItem> bottomNavItems = widget.role == 'Asesor'
        ? [
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code),
              label: 'QR',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'Información',
            ),
          ]
        : [
            BottomNavigationBarItem(
              icon: Icon(Icons.support),
              label: 'Asesorías',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.request_page),
              label: 'Solicitud',
            ),
          ];

    return Scaffold(
      appBar: AppBar(
        title: Text('HomeScreen'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: drawerItems,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Bienvenido',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Row(
                children: <Widget>[
                  Text(
                    widget.userName,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.role,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.person, size: 30),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Ejercicios',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Column(
                        children: <Widget>[
                          Image.network(
                            exercises[index]['image']!,
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 10),
                          Text(exercises[index]['name']!),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Top comunidades',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              SizedBox(height: 20),
              Column(
                children: exercises.map((exercise) {
                  return Card(
                    child: ListTile(
                      leading: Image.network(
                        exercise['image']!,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(exercise['name']!),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (widget.role == 'Asesor' && index == 0) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => QrScreen()));
          }
          // Añadir más lógica según sea necesario para otros índices del bottomNavigationBar
        },
        items: bottomNavItems,
      ),
    );
  }
}
