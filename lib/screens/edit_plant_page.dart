import 'package:flutter/material.dart';
import 'package:gardening_life/database/plant_database_helper.dart';
import 'package:gardening_life/models/plant.dart';

class EditPlantPage extends StatefulWidget {
  final Plant plant;

  const EditPlantPage({Key? key, required this.plant}) : super(key: key);

  @override
  _EditPlantPageState createState() => _EditPlantPageState();
}

class _EditPlantPageState extends State<EditPlantPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController actualNameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set default values from the selected plant
    nameController.text = widget.plant.name;
    actualNameController.text = widget.plant.actualName;
    typeController.text = widget.plant.type;
    descriptionController.text = widget.plant.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Plant'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Plant Name*'),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: actualNameController,
              decoration: InputDecoration(labelText: 'Actual Name*'),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: typeController,
              decoration: InputDecoration(labelText: 'Plant Type*'),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Plant Description*'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Create a new Plant object with updated values
                Plant updatedPlant = Plant(
                  id: widget.plant.id,
                  name: nameController.text,
                  actualName: actualNameController.text,
                  type: typeController.text,
                  description: descriptionController.text,
                  datePlanted: widget.plant.datePlanted,
                  imgURL: widget.plant.imgURL,
                );

                // Update the plant in the database
                PlantDatabaseHelper().updatePlant(updatedPlant);

                // Notify the previous screen about the update
                Navigator.pop(context, true);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Colors.green[900]!;
                  },
                ),
                foregroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Colors.white;
                  },
                ),
              ),
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
