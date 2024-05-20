import 'package:culture_explorer_ar/widgets/custom_marker.dart';
import 'package:culture_explorer_ar/widgets/custom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomIconButton extends StatefulWidget {
  final String _name;
  final String type;
  final Icon _icon;
  final Icon _selectedIcon;

  const CustomIconButton(
      {super.key, required this.type, required String name})
      : _icon = type == 'museum'
            ? const Icon(Icons.museum_outlined)
            : const Icon(Icons.palette_outlined),
        _selectedIcon = type == 'museum'
            ? const Icon(Icons.museum)
            : const Icon(Icons.palette),
        _name = name;

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
          final sheet = context.read<SheetNotifier>();

          if (!marker.isSelected) {
            setSelected();
            sheet.update(widget._name);
            marker.setSelection();
            marker.setSelectedMarker(this);
          } else if (_isSelected) {
            setSelected();
            sheet.update("Nearby Places");
            marker.setSelection();
          } else {
            setSelected();
            sheet.update(widget._name);
            marker.resetSelected(marker.selectedMarker!);
            marker.setSelectedMarker(this);
          }
        },
        icon: widget._icon,
        selectedIcon: widget._selectedIcon,
        tooltip: '${widget.type[0].toUpperCase()}${widget.type.substring(1)}',
      ),
    );
  }
}
