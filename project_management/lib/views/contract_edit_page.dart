import 'package:flutter/material.dart';

class ContractEditPage extends StatelessWidget {
  final Map<String, dynamic> contractData;

  const ContractEditPage({super.key, required this.contractData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chỉnh sửa hợp đồng")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Dự án: ${contractData["project"]["projectName"]}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Bên A: ${contractData["partyA"]["company"]}"),
            Text("Bên B: ${contractData["partyB"]["company"]}"),
            Text("Trạng thái: ${contractData["isDraft"] ? "Nháp" : "Chính thức"}"),
          ],
        ),
      ),
    );
  }
}
