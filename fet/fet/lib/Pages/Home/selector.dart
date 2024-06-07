import 'package:flutter/material.dart';

import '../../app.dart';

enum SelectionMethods {
  manual,
  picker,
  camera,
}

class SelectMethod extends StatelessWidget {
  final Function(SelectionMethods) onSelect;
  const SelectMethod({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    var camera = Bounce(
      duration: const Duration(milliseconds: 150),
      onPressed: () => onSelect(SelectionMethods.camera),
      child: Material(
        color: Color.fromARGB(255, 246, 246, 246),
        borderRadius: BorderRadius.circular(10),
        elevation: 1,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              Icon(Iconsax.camera, color: primaryColor, size: 30),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  "Camera",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
              Icon(FontAwesomeIcons.arrowRight, color: primaryColor, size: 15),
            ],
          ),
        ),
      ),
    );

    var library = Bounce(
      duration: const Duration(milliseconds: 150),
      onPressed: () => onSelect(SelectionMethods.picker),
      child: Material(
        color: Color.fromARGB(255, 246, 246, 246),
        borderRadius: BorderRadius.circular(10),
        elevation: 1,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              Icon(Iconsax.image, color: primaryColor, size: 30),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  "Select from photos",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
              Icon(FontAwesomeIcons.arrowRight, color: primaryColor, size: 15),
            ],
          ),
        ),
      ),
    );

    var search = Bounce(
      duration: const Duration(milliseconds: 150),
      onPressed: () => onSelect(SelectionMethods.manual),
      child: Material(
        color: const Color.fromARGB(255, 246, 246, 246),
        borderRadius: BorderRadius.circular(10),
        elevation: 1,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              Icon(Iconsax.search_normal, color: primaryColor, size: 30),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  "Search",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
              Icon(FontAwesomeIcons.arrowRight, color: primaryColor, size: 15),
            ],
          ),
        ),
      ),
    );

    var title = const Text(
      "Select Item",
      textAlign: TextAlign.center,
      style: TextStyle(
          color: primaryColor, fontSize: 25, fontWeight: FontWeight.bold),
    );

    return Material(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            title,
            const SizedBox(height: 30),
            camera,
            const SizedBox(height: 15),
            library,
            const SizedBox(height: 15),
            search,
          ],
        ),
      ),
    );
  }
}
