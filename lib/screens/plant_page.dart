// plant_page.dart
import 'package:flutter/material.dart';
import 'package:gardening_life/screens/edit_plant_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:gardening_life/models/plant.dart';

class PlantPage extends StatelessWidget {
  final Plant plant;

  const PlantPage({Key? key, required this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plant.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPlantPage(plant: plant),
                ),
              );
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
                    image: _getImageProvider(plant.imgURL),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              _buildAttributeRow('Actual Name:', plant.actualName),
              const SizedBox(height: 8.0),
              // Plant Details
              _buildAttributeRow('Type:', plant.type),
              const SizedBox(height: 8.0),
              _buildAttributeRow('Description:', plant.description),

              // Date Added
              const SizedBox(height: 8.0),
              _buildAttributeRow('Date Added:', _formatDate(plant.datePlanted)),

              const SizedBox(height: 16.0),

              // Wikipedia Link Button
              GestureDetector(
                onTap: () {
                  _launchWikipediaSearch(plant.actualName);
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
}
