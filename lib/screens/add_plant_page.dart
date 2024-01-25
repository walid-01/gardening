import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gardening_life/database/plant_database_helper.dart';
import 'package:gardening_life/models/plant.dart';
import 'package:image_picker/image_picker.dart';

class PlantAddPage extends StatefulWidget {
  @override
  _PlantAddPageState createState() => _PlantAddPageState();
}

class _PlantAddPageState extends State<PlantAddPage> {
  PlantDatabaseHelper databaseHelper = PlantDatabaseHelper();
  TextEditingController nameController = TextEditingController();
  TextEditingController actualNameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  PickedFile? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Plant'),
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
                    ? FileImage(File(selectedImage!.path))
                    : null,
                child: selectedImage == null
                    ? const Icon(
                        Icons.camera_alt,
                        size: 40,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Plant Name'),
              // Make the field required
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: actualNameController,
              decoration: InputDecoration(labelText: 'Actual Name'),
              // Make the field required
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: typeController,
              decoration: InputDecoration(labelText: 'Plant Type'),
              // Make the field required
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Plant Description'),
              // Make the field required
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                savePlant();
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
              child: Text('Save Plant'),
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

  void savePlant() async {
    // Check if any required field is empty
    if (nameController.text.isEmpty ||
        actualNameController.text.isEmpty ||
        typeController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      // Show an error message or handle accordingly
      showErrorMessage('Please fill all fields');
      return;
    }
    print(selectedImage?.path ?? '');

    // Create a new Plant object
    Plant newPlant = Plant(
      name: nameController.text,
      type: typeController.text,
      description: descriptionController.text,
      datePlanted: DateTime.now(),
      actualName: actualNameController.text,
      imgURL: selectedImage?.path ?? '',
    );

    // Save the plant to the database
    await databaseHelper.insertPlant(newPlant);

    // You can also navigate back to the PlantList page or any other page
    Navigator.pop(context);
  }

  void showErrorMessage(String message) {
    // Show a snackbar with the error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
