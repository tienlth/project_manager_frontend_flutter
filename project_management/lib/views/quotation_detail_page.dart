import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/bloc/quotation_cubit.dart';

class QuotationDetailPage extends StatefulWidget {
  final String quotationId;

  const QuotationDetailPage({super.key, required this.quotationId});

  @override
  State<QuotationDetailPage> createState() => _QuotationDetailPageState();
}

class _QuotationDetailPageState extends State<QuotationDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<QuotationCubit>().fetchQuotationDetail(widget.quotationId);
  }

  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chi tiết báo giá")),
      body: BlocBuilder<QuotationCubit, QuotationState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null) {
            return Center(child: Text(state.errorMessage!));
          }
          if (state.quotationDetail == null) {
            return const Center(child: Text("Không tìm thấy báo giá."));
          }

          final quotation = state.quotationDetail!;
          final project = quotation["project"];
          final taskCosts = quotation["taskCosts"];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoField("Dự án", project["projectName"]),
                _buildInfoField("Tổng chi phí", "${quotation["totalCost"]} VNĐ"),
                const SizedBox(height: 12),
                const Text(
                  "Chi tiết công việc:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Table(
                  border: TableBorder.all(color: Colors.black),
                  columnWidths: const {
                    0: FlexColumnWidth(2), // Cột tên công việc
                    1: FlexColumnWidth(1), // Cột chi phí
                  },
                  children: [
                    const TableRow(
                      decoration: BoxDecoration(color: Colors.grey),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Tên công việc", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Chi phí", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    ...List.generate(taskCosts.length, (index) {
                      final taskCost = taskCosts[index];
                      final task = project["tasks"].firstWhere(
                        (t) => t["_id"] == taskCost["taskId"],
                        orElse: () => null,
                      );

                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(task?["title"] ?? "Không xác định"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("${taskCost["cost"]} VNĐ"),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
