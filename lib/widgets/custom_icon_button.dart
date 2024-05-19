import 'package:culture_explorer_ar/widgets/custom_marker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomIconButton extends StatefulWidget {
  final int _index;
  final String _type;
  final Icon _icon;
  final Icon _selectedIcon;

  const CustomIconButton({super.key, required int index, required String type})
      : _index = index,
        _type = type,
        _icon = type == 'museum'
            ? const Icon(Icons.museum_outlined)
            : const Icon(Icons.palette_outlined),
        _selectedIcon = type == 'museum'
            ? const Icon(Icons.museum)
            : const Icon(Icons.palette);

  @override
  State<CustomIconButton> createState() => CustomIconButtonState();
}

class CustomIconButtonState extends State<CustomIconButton> {
  bool _isSelected = false;

  void setSelected() {
    setState(() => _isSelected = !_isSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarkerNotifier>(
      builder: (context, marker, child) => IconButton.filled(
        isSelected: _isSelected,
        onPressed: () {
          if (!marker.isSelected) {
            setSelected();
            marker.setSelection();
            marker.setSelectedMarker(this, widget._index);
          } else if (_isSelected) {
            setSelected();
            marker.setSelection();
          } else {
            setSelected();
            marker.resetSelected(marker.selectedMarker!);
            marker.setSelectedMarker(this, widget._index);
          }
        },
        icon: widget._icon,
        selectedIcon: widget._selectedIcon,
        tooltip: '${widget._type[0].toUpperCase()}${widget._type.substring(1)}',
      ),
    );
  }
}
