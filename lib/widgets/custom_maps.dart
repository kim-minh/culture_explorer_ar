import 'dart:async';
import 'package:culture_explorer_ar/overpass/overpass.dart';
import 'package:culture_explorer_ar/widgets/custom_marker.dart';
import 'package:culture_explorer_ar/widgets/custom_sheet.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class CustomMaps extends StatefulWidget {
  const CustomMaps({super.key});

  @override
  State<CustomMaps> createState() => _CustomMapsState();
}

class _CustomMapsState extends State<CustomMaps> {
  late AlignOnUpdate _alignPositionOnUpdate;
  late final StreamController<double?> _alignPositionStreamController;

  Timer? _timer;
  final _cacheStore = MemCacheStore();

  @override
  void initState() {
    super.initState();
    _alignPositionOnUpdate = AlignOnUpdate.always;
    _alignPositionStreamController = StreamController<double?>();
  }

  @override
  void dispose() {
    _alignPositionStreamController.close();
    super.dispose();
  }

  void getPlaces(LatLngBounds? bounds, MarkerNotifier marker) {
    _timer?.cancel();
    _timer = Timer(
        const Duration(milliseconds: 500),
        () => fetchPlaces(
                    '${bounds?.south},${bounds?.west},${bounds?.north}, ${bounds?.east}')
                .then((places) {
              marker.createMarkers(places);
              marker.resetSelection();
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SheetNotifier, MarkerNotifier>(
      builder: (context, sheet, marker, child) => FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(0, 0),
          initialZoom: 15,
          minZoom: 5,
          maxZoom: 18,
          // Stop aligning the location marker to the center of the map widget
          // if user interacted with the map.
          onPositionChanged: (MapPosition position, bool hasGesture) {
            sheet.update("Nearby Places");

            getPlaces(position.bounds, marker);
            if (hasGesture && _alignPositionOnUpdate != AlignOnUpdate.never) {
              setState(() => _alignPositionOnUpdate = AlignOnUpdate.never);
            }
          },
        ),
        // ignore: sort_child_properties_last
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
            tileProvider: CachedTileProvider(
              // use the store for your CachedTileProvider instance
              store: _cacheStore,
            ),
          ),
          CurrentLocationLayer(
            alignPositionStream: _alignPositionStreamController.stream,
            alignPositionOnUpdate: _alignPositionOnUpdate,
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FloatingActionButton(
                  onPressed: () {
                    // Align the location marker to the center of the map widget
                    // on location update until user interact with the map.
                    setState(
                        () => _alignPositionOnUpdate = AlignOnUpdate.always);
                    // Align the location marker to the center of the map widget
                    // and zoom the map to level 18.
                    _alignPositionStreamController.add(15);
                  },
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          MarkerClusterLayerWidget(
            options: MarkerClusterLayerOptions(
              maxClusterRadius: 45,
              size: const Size(40, 40),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(50),
              maxZoom: 15,
              markers: marker.markerList,
              rotate: true,
              builder: (context, markers) {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue),
                  child: Center(
                    child: Text(
                      markers.length.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
