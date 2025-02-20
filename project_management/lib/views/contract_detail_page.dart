import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/bloc/contract_cubit.dart';

class ContractDetailPage extends StatefulWidget {
  final String contractId;

  const ContractDetailPage({super.key, required this.contractId});

  @override
  State<ContractDetailPage> createState() => _ContractDetailPageState();
}

class _ContractDetailPageState extends State<ContractDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<ContractCubit>().fetchContractDetail(widget.contractId);
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          text: "$label: ",
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          children: [TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.normal))],
        ),
      ),
    );
  }

  Widget _buildTable({required String title, required List<List<dynamic>> rows}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        Table(
          border: TableBorder.all(color: Colors.black),
          columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(1)},
          children: [
            TableRow(
              decoration: const BoxDecoration(color: Colors.grey),
              children: rows.first.map((text) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
                );
              }).toList(),
            ),
            ...rows.sublist(1).map((row) {
              return TableRow(
                children: row.map((text) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(text),
                  );
                }).toList(),
              );
            }).toList(),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chi tiết hợp đồng")),
      body: BlocBuilder<ContractCubit, ContractState>(
        builder: (context, state) {
          if (state.isLoading) return const Center(child: CircularProgressIndicator());
          if (state.errorMessage != null) return Center(child: Text(state.errorMessage!));
          if (state.contractDetail == null) return const Center(child: Text("Không tìm thấy hợp đồng!"));

          final contract = state.contractDetail!;
          final project = contract["project"];
          final partyA = contract["partyA"];
          final partyB = contract["partyB"];
          final paymentTerms = contract["paymentTerms"];
          final installments = paymentTerms["installments"];
          final tasks = project["tasks"];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("HỢP ĐỒNG DỰ ÁN"),
                  _buildInfoField("Tên dự án", project["projectName"]),
                  _buildInfoField("Mô tả", project["description"]),
                  // _buildInfoField("Trạng thái", project["status"]),

                  const SizedBox(height: 16),
                  _buildSectionTitle("BÊN A"),
                  _buildInfoField("Công ty", partyA["company"]),
                  _buildInfoField("Địa chỉ", partyA["address"]),
                  _buildInfoField("Mã số thuế", partyA["taxCode"]),
                  _buildInfoField("Người đại diện", partyA["representative"]),
                  _buildInfoField("Chức vụ", partyA["position"]),
                  _buildInfoField("Điện thoại", partyA["phone"]),
                  _buildInfoField("Email", partyA["email"]),

                  const SizedBox(height: 16),
                  _buildSectionTitle("BÊN B"),
                  _buildInfoField("Công ty", partyB["company"]),
                  _buildInfoField("Địa chỉ", partyB["address"]),
                  _buildInfoField("Mã số thuế", partyB["taxCode"]),
                  _buildInfoField("Người đại diện", partyB["representative"]),
                  _buildInfoField("Chức vụ", partyB["position"]),
                  _buildInfoField("Điện thoại", partyB["phone"]),
                  _buildInfoField("Email", partyB["email"]),

                  const SizedBox(height: 16),
                  _buildSectionTitle("ĐIỀU KHOẢN THANH TOÁN"),
                  _buildInfoField("Phương thức thanh toán", paymentTerms["method"]),
                  _buildInfoField("Ngân hàng", paymentTerms["bankDetails"]["bankName"]),
                  _buildInfoField("Chi nhánh", paymentTerms["bankDetails"]["branch"]),
                  _buildInfoField("Số tài khoản", paymentTerms["bankDetails"]["accountNumber"]),
                  _buildInfoField("Chủ tài khoản", paymentTerms["bankDetails"]["accountName"]),

                  if (installments.isNotEmpty)
                    _buildTable(
                      title: "Lịch thanh toán",
                      rows: [
                        ["Đợt", "Số tiền"],
                        ...installments.map((installment) => [
                          installment["stage"],
                          "${installment["amount"]} VNĐ"
                        ])
                      ],
                    ),

                  if (tasks.isNotEmpty)
                    _buildTable(
                      title: "Danh sách công việc",
                      rows: [
                        ["Tên công việc", "Mô tả", "Chi phí"],
                        ...tasks.map((task) => [
                          task["title"],
                          task["description"],
                          '${contract["quotation"]["taskCosts"].firstWhere(
                              (t) => t["taskId"] == task["_id"])["cost"]} VND'
                        ])
                      ],
                    ),

                  const SizedBox(height: 16),
                  _buildSectionTitle("ĐIỀU KHOẢN HỢP ĐỒNG"),
                  _buildInfoField("Bảo hành và hỗ trợ", contract["warrantyAndSupport"]),
                  _buildInfoField("Điều khoản chấm dứt", contract["terminationClause"]),
                  _buildInfoField("Hiệu lực hợp đồng", contract["contractEffectiveness"]),

                  const SizedBox(height: 16),
                  _buildSectionTitle("TRÁCH NHIỆM CÁC BÊN"),
                  _buildInfoField("Trách nhiệm Bên A", contract["rightsAndObligations"]["partyA"]["responsibilities"].join(", ")),
                  _buildInfoField("Trách nhiệm Bên B", contract["rightsAndObligations"]["partyB"]["responsibilities"].join(", ")),

                  // const SizedBox(height: 16),
                  // _buildInfoField("Ngày tạo", contract["createdAt"]),
                  // _buildInfoField("Cập nhật lần cuối", contract["updatedAt"]),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
