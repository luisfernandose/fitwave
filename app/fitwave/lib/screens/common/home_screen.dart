import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HomeScreen Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> exercises = [
    {
      "name": "Push Ups",
      "image": "https://cdn.pixabay.com/photo/2016/11/29/09/32/sport-1867968_960_720.jpg"
    },
    {
      "name": "Squats",
      "image": "https://cdn.pixabay.com/photo/2014/12/03/10/03/weights-554154_960_720.jpg"
    },
    {
      "name": "Lunges",
      "image": "https://cdn.pixabay.com/photo/2017/08/02/01/01/lunge-2571855_960_720.jpg"
    },
    {
      "name": "Planks",
      "image": "https://cdn.pixabay.com/photo/2016/11/21/16/10/plank-1846127_960_720.jpg"
    },
    {
      "name": "Jumping Jacks",
      "image": "https://cdn.pixabay.com/photo/2016/03/27/21/39/sport-1283796_960_720.jpg"
    }
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    // Handle navigation to different screens based on index
    // For simplicity, we are just changing the index here
    _selectedIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeScreen'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Luis',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'luis@example.com',
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
                Navigator.pop(context);
              },
            ),
          ],
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
                    'Luis',
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Opción 1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Opción 2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Opción 3',
          ),
        ],
      ),
    );
  }
}
