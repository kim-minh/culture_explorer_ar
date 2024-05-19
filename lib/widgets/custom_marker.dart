import 'package:culture_explorer_ar/overpass/place_model.dart';
import 'package:culture_explorer_ar/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class MarkerNotifier with ChangeNotifier {
  List<CustomMarker> _markerList = [];
  List<CustomMarker> get markerList => List.unmodifiable(_markerList);

  bool _isSelected = false;
  bool get isSelected => _isSelected;

  CustomIconButtonState? _selectedMarker;
  CustomIconButtonState? get selectedMarker => _selectedMarker;

  int _selectedMarkerIndex = -1;
  int get selectedMarkerIndex => _selectedMarkerIndex;

  void resetSelected(CustomIconButtonState marker) {
    marker.setSelected();
    _selectedMarkerIndex = -1;
    notifyListeners();
  }

  void setSelectedMarker(CustomIconButtonState marker, int index) {
    _selectedMarker = marker;
    _selectedMarkerIndex = index;
    notifyListeners();
  }

  void createMarkers(List<Place> places) {
    _markerList = places
        .asMap()
        .map((key, place) => MapEntry(
            key,
            CustomMarker(
              point: place.position,
              index: key,
              name: place.tags.name ?? place.tags.nameEn ?? "Not Provided",
              type: place.tags.tourism,
            )))
        .values
        .toList();
    notifyListeners();
  }

  void resetSelection() {
    _isSelected = false;
    notifyListeners();
  }

  void setSelection() {
    _isSelected = !_isSelected;
    notifyListeners();
  }
}

@immutable
class CustomMarker extends Marker {
  final int index;
  final String name;
  final String type;

  CustomMarker({required super.point, required this.index, required this.name, required this.type})
      : super(rotate: true, child: CustomIconButton(index: index, type: type));
}
