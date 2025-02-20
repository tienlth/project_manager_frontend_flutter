import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/bloc/contract_cubit.dart';
import 'package:project_management/views/contract_detail_page.dart';
import 'package:project_management/views/contract_edit_page.dart';

class ContractsPage extends StatefulWidget {
  const ContractsPage({super.key});

  @override
  State<ContractsPage> createState() => _ContractsPageState();
}

class _ContractsPageState extends State<ContractsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ContractCubit>().fetchContracts();
  }

  void _navigateToContract(BuildContext context, Map<String, dynamic> contract) {
    final String contractId = contract["_id"];
    final bool isDraft = contract["isDraft"] ?? true;

    if (isDraft) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ContractEditPage(contractData: contract),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ContractDetailPage(contractId: contractId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: BlocBuilder<ContractCubit, ContractState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.errorMessage != null) {
                return Center(child: Text(state.errorMessage!));
              }
              if (state.contracts.isEmpty) {
                return const Center(child: Text("Không có hợp đồng nào."));
              }
              return ListView.builder(
                itemCount: state.contracts.length,
                itemBuilder: (context, index) {
                  final contract = state.contracts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      title: Text(
                        "Hợp đồng dự án: ${contract["project"]["projectName"]}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Bên A: ${contract["partyA"]["company"]}"),
                          Text("Bên B: ${contract["partyB"]["company"]}"),
                          Text("Trạng thái: ${contract["isDraft"] ? "Nháp" : "Chính thức"}"),
                        ],
                      ),
                      onTap: () => _navigateToContract(context, contract),
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
