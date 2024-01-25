import 'package:flutter/material.dart';
import 'package:gardening_life/database/plant_database_helper.dart';
import 'package:gardening_life/models/plant.dart';
import 'package:gardening_life/screens/add_plant_page.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // PlantDatabaseHelper databaseHelper = PlantDatabaseHelper();
  // await databaseHelper.insertTestPlants();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
            .copyWith(background: Colors.lightGreen[50]),
      ),
      home: PlantList(),
    );
  }
}

class PlantList extends StatefulWidget {
  const PlantList({Key? key}) : super(key: key);

  @override
  _PlantListState createState() => _PlantListState();
}

class _PlantListState extends State<PlantList> {
  PlantDatabaseHelper databaseHelper = PlantDatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gardening Life'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Theme.of(context).colorScheme.background,
        child: FutureBuilder<List<Plant>>(
          future: databaseHelper.getPlants(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('Press + to add plants.');
            } else {
              List<Plant> plants = snapshot.data!;
              return ListView.builder(
                itemCount: plants.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.green[50],
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(plants[index].name),
                      subtitle: Text(plants[index].type),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PlantPage(plant: plants[index]),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the screen to add a new plant
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PlantAddPage()),
          );
        },
        backgroundColor: Colors.lightGreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PlantPage extends StatelessWidget {
  final Plant plant;

  const PlantPage({Key? key, required this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plant.name),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Theme.of(context).colorScheme.background,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Plant Image
              Container(
                height: 200.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  image: DecorationImage(
                    image: NetworkImage(plant.imgURL),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Actual Name: ${plant.actualName}',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              // Plant Details
              Text(
                'Type: ${plant.type}',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              Text(
                'Description: ${plant.description}',
                style: TextStyle(fontSize: 16.0),
              ),

              // Date Planted
              SizedBox(height: 8.0),
              Text(
                'Date Planted: ${_formatDate(plant.datePlanted)}',
                style: TextStyle(fontSize: 16.0),
              ),

              SizedBox(height: 8.0),

              // Wikipedia Link Button
              GestureDetector(
                onTap: () {
                  _launchWikipediaSearch(plant.actualName);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Wikipedia Search',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Format the date as needed
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _launchWikipediaSearch(String query) async {
    final searchUrl = 'https://en.wikipedia.org/w/index.php?search=$query';
    if (await canLaunch(searchUrl)) {
      await launch(searchUrl);
    } else {
      throw 'Could not launch $searchUrl';
    }
  }
}
