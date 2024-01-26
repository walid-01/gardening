import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gardening_life/database/plant_database_helper.dart';
import 'package:gardening_life/models/plant.dart';
import 'package:image_picker/image_picker.dart';

class EditPlantPage extends StatefulWidget {
  final Plant plant;
  final Function updateMainFrame;
  final Function updateEditFrame;

  const EditPlantPage(
      {Key? key,
      required this.plant,
      required this.updateMainFrame,
      required this.updateEditFrame})
      : super(key: key);
  @override
  _EditPlantPageState createState() => _EditPlantPageState();
}

class _EditPlantPageState extends State<EditPlantPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController actualNameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late PickedFile selectedImage;

  @override
  void initState() {
    super.initState();
    // Set default values from the selected plant
    nameController.text = widget.plant.name;
    actualNameController.text = widget.plant.actualName;
    typeController.text = widget.plant.type;
    descriptionController.text = widget.plant.description;
    selectedImage = PickedFile(widget.plant.imgURL);
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
            GestureDetector(
              onTap: () {
                pickImage();
              },
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.green[900],
                backgroundImage: selectedImage != null
                    ? FileImage(File(selectedImage.path))
                    : null,
                child: selectedImage.path.length == 0
                    ? const Icon(
                        Icons.camera_alt,
                        size: 40,
                      )
                    : null,
              ),
            ),
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
            DropdownButtonFormField<String>(
              value: typeController.text.isEmpty ? null : typeController.text,
              onChanged: (String? value) {
                setState(() {
                  typeController.text = value ?? '';
                });
              },
              items: ["Flower", "Vegetable", "Fruit"].map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Plant Type'),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Plant Description*'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                // Create a new Plant object with updated values
                Plant updatedPlant = Plant(
                  id: widget.plant.id,
                  name: nameController.text,
                  actualName: actualNameController.text,
                  type: typeController.text,
                  description: descriptionController.text,
                  datePlanted: widget.plant.datePlanted,
                  imgURL: selectedImage == null
                      ? widget.plant.imgURL
                      : selectedImage.path,
                );

                // Update the plant in the database
                PlantDatabaseHelper().updatePlant(updatedPlant);

                //update main frame
                widget.updateMainFrame();

                //update edite page
                widget.updateEditFrame(updatedPlant);
                PlantDatabaseHelper databaseHelper = PlantDatabaseHelper();
                List<Plant> listPlants = await databaseHelper.getPlants();

                for (Plant p in listPlants) {
                  print(p.toMap());
                }

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

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        selectedImage = PickedFile(pickedFile.path);
      }
    });
  }
}
