import 'dart:math' as math;
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class ARView extends StatefulWidget {
  final String? model;
  
  const ARView({super.key, this.model});

  @override
  State<ARView> createState() => _ARViewState();
}

class _ARViewState extends State<ARView> {
  late ARKitController arkitController;
  ARKitNode? node;

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('AR View')),
        body: ARKitSceneView(
          enablePinchRecognizer: true,
          enablePanRecognizer: true,
          enableRotationRecognizer: true,
          planeDetection: ARPlaneDetection.horizontalAndVertical,
          onARKitViewCreated: onARKitViewCreated,
        ),
      );

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.onNodePinch = (pinch) => _onPinchHandler(pinch);
    this.arkitController.onNodePan = (pan) => _onPanHandler(pan);
    this.arkitController.onNodeRotation =
        (rotation) => _onRotationHandler(rotation);

    addNode();
  }

  void addNode() {
    final model = ARKitGltfNode(
      assetType: AssetType.flutterAsset,
      url: 'assets/models/${widget.model}',
      scale: Vector3(0.5, 0.5, 0.5),
      position: Vector3(0, 0, -1),
    );

    arkitController.add(model);
    node = model;
  }

  void _onPinchHandler(List<ARKitNodePinchResult> pinch) {
    final pinchNode = pinch.firstWhereOrNull(
          (e) => e.nodeName == node?.name,
    );
    if (pinchNode != null) {
      final scale = Vector3.all(pinchNode.scale);
      node?.scale = scale;
    }
  }

  void _onPanHandler(List<ARKitNodePanResult> pan) {
    final panNode = pan.firstWhereOrNull((e) => e.nodeName == node?.name);
    if (panNode != null) {
      final old = node?.eulerAngles;
      final newAngleY = panNode.translation.x * math.pi / 180;
      node?.eulerAngles =
          Vector3(old?.x ?? 0, newAngleY, old?.z ?? 0);
    }
  }

  void _onRotationHandler(List<ARKitNodeRotationResult> rotation) {
    final rotationNode = rotation.firstWhereOrNull(
          (e) => e.nodeName == node?.name,
    );
    if (rotationNode != null) {
      final rotation = node?.eulerAngles ??
          Vector3.zero() + Vector3.all(rotationNode.rotation);
      node?.eulerAngles = rotation;
    }
  }
}

