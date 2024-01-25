class Plant {
  late String name;
  late String type;
  late String description;
  late String imgURL;
  late String actualName;
  late DateTime datePlanted;

  Plant({
    required this.name,
    required this.type,
    required this.description,
    required this.imgURL,
    required this.actualName,
    required this.datePlanted,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'description': description,
      'imgURL': imgURL,
      'actualName': actualName,
      'datePlanted': datePlanted
          .toLocal()
          .toString()
          .split(' ')[0], // Extracting only the date part as a string
    };
  }

  Plant.fromMap(Map<String, dynamic> map) {
    name = map['name']!;
    type = map['type']!;
    description = map['description']!;
    imgURL = map['imgURL']!;
    actualName = map['actualName']!;

    // Parse the date from the string to a DateTime object
    datePlanted = DateTime.parse(map['datePlanted']!);
  }
}
