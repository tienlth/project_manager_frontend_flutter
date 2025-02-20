import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/network/services/contract_api_service.dart';

class ContractState {
  final List<dynamic> contracts;
  final Map<String, dynamic>? contractDetail;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  ContractState({
    this.contracts = const [],
    this.contractDetail,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  ContractState copyWith({
    List<dynamic>? contracts,
    Map<String, dynamic>? contractDetail,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return ContractState(
      contracts: contracts ?? this.contracts,
      contractDetail: contractDetail ?? this.contractDetail,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

class ContractCubit extends Cubit<ContractState> {
  final ContractApiService _contractService = ContractApiService();

  ContractCubit() : super(ContractState());

  Future<void> fetchContracts() async {
    emit(state.copyWith(isLoading: true, errorMessage: null, successMessage: null));

    try {
      final contracts = await _contractService.fetchAllContracts();
      emit(state.copyWith(isLoading: false, contracts: contracts));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: "Lỗi khi lấy danh sách hợp đồng!"));
    }
  }

  Future<void> fetchContractDetail(String contractId) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, successMessage: null));

    try {
      final contractDetail = await _contractService.fetchContractById(contractId);
      emit(state.copyWith(isLoading: false, contractDetail: contractDetail));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: "Lỗi khi lấy chi tiết hợp đồng!"));
    }
  }
}
