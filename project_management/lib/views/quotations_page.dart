import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/bloc/quotation_cubit.dart';
import 'quotation_detail_page.dart';

class QuotationsPage extends StatefulWidget {
  const QuotationsPage({super.key});

  @override
  State<QuotationsPage> createState() => _QuotationsPageState();
}

class _QuotationsPageState extends State<QuotationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<QuotationCubit>().fetchQuotations();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: BlocBuilder<QuotationCubit, QuotationState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.errorMessage != null) {
                return Center(child: Text(state.errorMessage!));
              }
              if (state.quotations.isEmpty) {
                return const Center(child: Text("Không có báo giá nào."));
              }
              return ListView.builder(
                itemCount: state.quotations.length,
                itemBuilder: (context, index) {
                  final quotation = state.quotations[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      title: Text(
                        "Báo giá cho: ${quotation["project"]["projectName"]}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Tổng chi phí: ${quotation["totalCost"]} VNĐ"),
                          Text("Số công việc: ${quotation["taskCosts"].length}"),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuotationDetailPage(quotationId: quotation["_id"]),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
