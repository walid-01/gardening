import 'package:flutter/material.dart';
import 'package:gardening_life/database/plant_database_helper.dart';
import 'package:gardening_life/models/plant.dart';
import 'package:gardening_life/screens/add_plant_page.dart';
import 'package:gardening_life/screens/plant_page.dart';

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
  List<Plant> plants = [];

  @override
  void initState() {
    super.initState();
    // Fetch the initial list of plants when the widget is created
    fetchPlants();
  }

  Future<void> fetchPlants() async {
    // Fetch the list of plants from the database
    List<Plant> updatedPlants = await databaseHelper.getPlants();

    // Update the UI with the new list of plants
    setState(() {
      plants = updatedPlants;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gardening Life'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Theme.of(context).colorScheme.background,
        child: plants.isEmpty
            ? Center(
                child: Text(
                  'No plant added yet, press + to start adding',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : ListView.builder(
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
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to the add plant page and wait for result
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlantAddPage(),
            ),
          );

          // Fetch the updated list of plants when returning from PlantAddPage or EditPlantPage
          fetchPlants();
        },
        backgroundColor: Colors.green[900],
        child: const Icon(Icons.add),
      ),
    );
  }
}
