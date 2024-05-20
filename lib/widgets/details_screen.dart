import 'package:culture_explorer_ar/ar/panorama_view.dart';
import 'package:culture_explorer_ar/widgets/custom_grid.dart';
import 'package:culture_explorer_ar/widgets/custom_marker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatelessWidget {
  final CustomMarker marker;

  const DetailsScreen({super.key, required this.marker});

  @override
  Widget build(BuildContext context) {
    final Uri url = Uri.parse(
        "https://www.google.com/maps/dir/?api=1&destination=${marker.point.latitude},${marker.point.longitude}");
    return Scaffold(
        appBar: AppBar(
          title: Text(marker.name),
        ),
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                ElevatedButton.icon(
                    onPressed: () => launchUrl(url),
                    icon: const Icon(Icons.directions),
                    label: const Text("Direction")),
                ElevatedButton.icon(
                    onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PanoramaView(
                                  url: 'assets/panaroma_images/panorama_image.png'),
                            ),
                          )
                        },
                    icon: const Icon(Icons.panorama_photosphere),
                    label: const Text("Panorama Photo")),
              ],
            ),
            Expanded(
              child: GridView.builder(
                  gridDelegate: CustomGridDelegate(),
                  //TODO: Create a list of model and get its length here
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        onTap: () => {}, //TODO: Navigate to AR model
                        child: Column(
                          children: [
                            //TODO: Get model's name from list,
                            Text("Model $index"),
                            //TODO: Model's image hay gì đó để nhận biết model
                            const Image(
                                image: NetworkImage(
                                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'))
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ));
  }
}
