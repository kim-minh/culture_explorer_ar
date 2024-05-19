import 'package:culture_explorer_ar/widgets/details_screen.dart';
import 'package:flutter/material.dart';
import 'custom_marker.dart';

class CustomCard extends StatelessWidget {
  final CustomMarker marker;
  const CustomCard({
    super.key,
    required this.marker,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12.0),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  barrierDismissible: true,
                  builder: (context) => DetailsScreen(marker: marker)));
        },
        child: Icon(
          marker.type == 'museum'
              ? Icons.museum_outlined
              : Icons.palette_outlined,
          size: 40,
        ),
      ),
    );
  }
}
