import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Entry point of the application
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        textTheme: Theme.of(context).textTheme.copyWith(
              bodyLarge: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomePage(),
    const DataPage(),
    const ContactPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.data_usage), label: 'Data'),
          NavigationDestination(
              icon: Icon(Icons.contact_page), label: 'Contact'),
        ],
      ),
    );
  }
}

// Home Page ******************************************************************************
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://placedog.net/300'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.rotate(
                        angle: 0,
                        child: Text(
                          'Why Dogs Are Man’s Best Friend',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Dogs are one of the most loyal, loving creatures on Earth. From playful puppies to wise old companions, every dog has a unique personality that can melt hearts.\n\nWhether it’s a big fluffy husky or a small energetic terrier, dogs remind us that unconditional love and companionship are what make life beautiful.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Data Page ***********************************************************************************
class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  late Future<List<Product>> _data;

  @override
  void initState() {
    super.initState();
    _data = fetchData();
  }

  Future<List<Product>> fetchData() async {
    final response = await http.get(Uri.parse('http://dummyjson.com/products'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['products'];
      return jsonData
          .map((data) => Product(
                id: data['id'],
                name: data['title'],
                description: data['description'],
                thumbnail: data['thumbnail'],
              ))
          .toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Product>>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      data[index].thumbnail,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                    title: Text(data[index].name),
                    subtitle: Text(data[index].description),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

class Product {
  final int id;
  final String name;
  final String description;
  final String thumbnail;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnail,
  });
}

//Contact Page *********************************************************************************
class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Two')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Want something? Tell us.',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.black), // ***************************
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(
                  color: Colors.black, // ********************************
                ),
                autofocus: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Enter your name',
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ), // ***** Updated code ****
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ), // ********************************
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your name'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                style: const TextStyle(
                  color: Colors.black, //*******************************
                ),
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'Enter your email',
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ), // *************************************
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ), // *************************************
                ),
                validator: (value) => value == null || !value.contains('@')
                    ? 'Enter a valid email'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _messageController,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16, // INPUT TEXT SIZE
                ),
                maxLines: 3,
                decoration: const InputDecoration(
                  icon: Icon(Icons.message),
                  hintText: 'Enter your message',
                  labelText: 'Request Message',
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a message'
                    : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Submitting Form')));
                  }
                },
                child: const Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
