import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/network/services/Contract_api_service.dart';

class ContractState {
  final List<dynamic> contracts;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  ContractState({
    this.contracts = const [],
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  ContractState copyWith({
    List<dynamic>? contracts,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return ContractState(
      contracts: contracts ?? this.contracts,
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
      emit(state.copyWith(isLoading: false, errorMessage: "Getting data error!"));
    }
  }
}
