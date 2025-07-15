import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

class LearningFlowchart extends StatelessWidget {
  final List<Map<String, dynamic>> nodesData;

  const LearningFlowchart({super.key, required this.nodesData});

  @override
  Widget build(BuildContext context) {
    final Graph graph = Graph();
    final Map<String, Node> nodeMap = {};

    // Create nodes
    for (var node in nodesData) {
      if (node['id'] != null) {
        nodeMap[node['id']] = Node(_FlowchartNodeWidget(
          label: node['label'],
          isActive: node['isActive'] ?? false,
        ));
        graph.addNode(nodeMap[node['id']]!);
      }
    }

    // Create edges
    for (var node in nodesData) {
      if (node['next'] != null &&
          node['id'] != null &&
          nodeMap[node['id']] != null) {
        for (var nextId in node['next']) {
          if (nodeMap[nextId] != null) {
            graph.addEdge(nodeMap[node['id']]!, nodeMap[nextId]!);
          }
        }
      }
    }

    final BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration()
      ..siblingSeparation = (20)
      ..levelSeparation = (30)
      ..subtreeSeparation = (20)
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;

    return SizedBox(
      height: 250,
      child: GraphView(
        graph: graph,
        algorithm: BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
        paint: Paint()
          ..color = Colors.black
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke,
        builder: (Node node) {
          return node.key != null
              ? node.key!.value as Widget
              : const SizedBox.shrink();
        },
      ),
    );
  }
}

class _FlowchartNodeWidget extends StatelessWidget {
  final String label;
  final bool isActive;

  const _FlowchartNodeWidget({required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isActive ? Colors.orange[200] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
