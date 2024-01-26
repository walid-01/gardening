import 'package:flutter/material.dart';
import 'package:gardening_life/database/plant_database_helper.dart';
import 'package:gardening_life/models/plant.dart';
import 'package:gardening_life/screens/add_plant_page.dart';
import 'package:gardening_life/screens/plant_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

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
  List<Plant> filteredPlants = [];
  String selectedCategory = 'All'; // Initial category

  Future<void> updateFilteredPlants(String category) async {
    List<Plant> filteredPlants;
    switch (category) {
      case 'Flower':
        filteredPlants = await databaseHelper.getFlowerPlants();
        break;
      case 'Vegetable':
        filteredPlants = await databaseHelper.getVegetablePlants();
        break;
      case 'Fruit':
        filteredPlants = await databaseHelper.getFruitPlants();
        break;
      default:
        filteredPlants = await databaseHelper.getPlants();
    }
    setState(() {
      plants = filteredPlants;
      selectedCategory = category;
    });
  }

  Future<void> UpdatePlantList() async {
    List<Plant> updatedPlants = await databaseHelper.getPlants();
    setState(() {
      plants = updatedPlants;
      selectedCategory = 'All';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gardening Life'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PlantSearchDelegate(plants),
              );
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Theme.of(context).colorScheme.background,
        child: plants.isEmpty
            ? const Center(
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
                            builder: (context) => PlantPage(
                              plant: plants[index],
                              callback: UpdatePlantList,
                            ),
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
          UpdatePlantList();
        },
        backgroundColor: Colors.green[900],
        child: const Icon(Icons.add),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon:
                Image.asset('assets/icons/infinity.png', width: 24, height: 24),
            label: 'All',
          ),
          BottomNavigationBarItem(
            icon:
                Image.asset('assets/icons/jasmine.png', width: 24, height: 24),
            label: 'Flowers',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/vegetables.png',
                width: 24, height: 24),
            label: 'Vegetables',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/fruits.png', width: 24, height: 24),
            label: 'Fruits',
          ),
        ],
        currentIndex: selectedCategory == 'All'
            ? 0
            : selectedCategory == 'Flower'
                ? 1
                : selectedCategory == 'Vegetable'
                    ? 2
                    : 3,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: (index) {
          // Update filtered plants based on the selected category
          switch (index) {
            case 0:
              updateFilteredPlants('All');
              break;
            case 1:
              updateFilteredPlants('Flower');
              break;
            case 2:
              updateFilteredPlants('Vegetable');
              break;
            case 3:
              updateFilteredPlants('Fruit');
              break;
          }
        },
      ),
    );
  }
}

class PlantSearchDelegate extends SearchDelegate<String> {
  final List<Plant> plants;

  PlantSearchDelegate(this.plants);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Filter plants based on the search query
    final filteredPlants = plants
        .where(
            (plant) => plant.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildSearchResults(filteredPlants);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Suggestions are not implemented in this example
    return Container();
  }

  Widget _buildSearchResults(List<Plant> searchResults) {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(searchResults[index].name),
          subtitle: Text(searchResults[index].type),
          onTap: () {
            // Handle tap on search result
            // For example, navigate to PlantPage
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlantPage(
                  plant: searchResults[index],
                  callback: () {
                    // UpdatePlantList() or any other callback
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
