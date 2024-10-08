// plant_page.dart
import 'package:flutter/material.dart';
import 'package:gardening_life/database/plant_database_helper.dart';
import 'package:gardening_life/screens/edit_plant_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:gardening_life/models/plant.dart';

// ignore: must_be_immutable
class PlantPage extends StatefulWidget {
  Plant plant;
  final Function callback;

  PlantPage({Key? key, required this.plant, required this.callback})
      : super(key: key);

  @override
  State<PlantPage> createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  void updatePlant(Plant plant) {
    setState(() {
      widget.plant = plant;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plant.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPlantPage(
                    plant: widget.plant,
                    updateMainFrame: widget.callback,
                    updateEditFrame: updatePlant,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmation(context);
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Theme.of(context).colorScheme.background,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Plant Image or Placeholder
              Container(
                height: 200.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  image: DecorationImage(
                    image: _getImageProvider(widget.plant.imgURL),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Plant Details
              const SizedBox(height: 16.0),
              _buildAttributeRow('Actual Name:', widget.plant.actualName),
              const SizedBox(height: 8.0),
              _buildAttributeRow('Type:', widget.plant.type),
              const SizedBox(height: 8.0),
              _buildAttributeRow('Description:', widget.plant.description),

              // Date Added
              const SizedBox(height: 8.0),
              _buildAttributeRow(
                  'Date Added:', _formatDate(widget.plant.datePlanted)),

              const SizedBox(height: 16.0),

              // Wikipedia Link Button
              GestureDetector(
                onTap: () {
                  _launchWikipediaSearch(widget.plant.actualName);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green[900],
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Wikipedia Search',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttributeRow(String attributeName, String attributeValue) {
    return Row(
      children: [
        Text(
          '$attributeName',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.green[900], // Dark green color
            fontWeight: FontWeight.bold, // Slightly more bold
          ),
        ),
        const SizedBox(width: 8.0),
        Text(
          '$attributeValue',
          style: TextStyle(fontSize: 16.0),
        ),
      ],
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

  // Function to determine the image provider based on imgURL
  ImageProvider _getImageProvider(String imgURL) {
    if (imgURL.isNotEmpty) {
      return FileImage(File(imgURL));
    } else {
      // Placeholder image when imgURL is empty
      return const AssetImage('assets/plant_placeholder.png');
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Plant'),
          content: const Text('Are you sure you want to delete this plant?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deletePlant(context);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deletePlant(BuildContext context) async {
    // Perform the delete operation in the database
    await PlantDatabaseHelper().deletePlant(widget.plant.id);
    this.widget.callback();
    // Navigate back to the home page by popping until reaching the root
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
