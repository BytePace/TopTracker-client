import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';

class InvitedOnProject extends StatelessWidget {
  final DetailProjectModel detailProjectModel;
  const InvitedOnProject({super.key, required this.detailProjectModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: List.generate(
          detailProjectModel.invitations.length,
          (index) => Container(
            height: 50,
            color: Colors.grey[100],
            child: Row(
              children: [
                Text(detailProjectModel.invitations[index].name ?? "name"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
