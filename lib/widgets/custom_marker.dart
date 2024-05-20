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

  void resetSelected(CustomIconButtonState state) {
    state.setSelected();
    notifyListeners();
  }

  void setSelectedMarker(CustomIconButtonState marker) {
    _selectedMarker = marker;
    notifyListeners();
  }

  void createMarkers(List<Place> places) {
    _markerList = places
        .map((place) => CustomMarker(
              point: place.position,
              name: place.tags.name ?? place.tags.nameEn ?? "Not Provided",
              type: place.tags.tourism,
            ))
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
  final String name;
  final String type;

  CustomMarker({required super.point, required this.name, required this.type})
      : super(rotate: true, child: CustomIconButton(name: name, type: type));
}
