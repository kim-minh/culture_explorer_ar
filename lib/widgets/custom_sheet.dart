import 'package:culture_explorer_ar/widgets/custom_grid.dart';
import 'package:culture_explorer_ar/widgets/custom_marker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'custom_card.dart';

class CustomSheet extends StatefulWidget {
  const CustomSheet({super.key});

  @override
  State<CustomSheet> createState() => _CustomSheetState();
}

class _CustomSheetState extends State<CustomSheet> {
  final _controller = DraggableScrollableController();
  final _initialChildSize = 0.25;
  final _maxChildSize = 1.0;
  final _minChildSize = 0.1;
  final _snapSizes = [0.25];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: _initialChildSize,
      maxChildSize: _maxChildSize,
      minChildSize: _minChildSize,
      expand: false,
      snap: true,
      snapSizes: _snapSizes,
      controller: _controller,
      builder: (BuildContext context, scrollController) =>
          SheetBody(scrollController: scrollController),
    );
  }
}

class SheetBody extends StatelessWidget {
  final ScrollController scrollController;

  const SheetBody({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Consumer<MarkerNotifier>(
        builder: (context, marker, child) => CustomScrollView(
          controller: scrollController,
          scrollBehavior: const ScrollBehavior().copyWith(dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          }),
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  height: 4,
                  width: 40,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            const SliverAppBar(
              title: Text("Nearby Places"),
              primary: false,
              pinned: true,
              centerTitle: false,
            ),
            SliverGrid.builder(
                gridDelegate: CustomGridDelegate(),
                itemCount: marker.isSelected ? 1 : marker.markerList.length,
                itemBuilder: (BuildContext context, int index) {
                  if (marker.isSelected) {
                    index = marker.selectedMarkerIndex;
                  }
                  return GridTile(
                    header: GridTileBar(
                      title: Text(marker.markerList[index].name,
                          style: const TextStyle(color: Colors.black)),
                    ),
                    child: CustomCard(marker: marker.markerList[index]),
                  );
                })
          ],
        ),
      ),
    );
  }
}
