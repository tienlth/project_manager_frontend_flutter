import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/network/services/quotation_api_service.dart';

class QuotationState {
  final List<dynamic> quotations;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  QuotationState({
    this.quotations = const [],
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  QuotationState copyWith({
    List<dynamic>? quotations,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return QuotationState(
      quotations: quotations ?? this.quotations,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

class QuotationCubit extends Cubit<QuotationState> {
  final QuotationApiService _quotationService = QuotationApiService();

  QuotationCubit() : super(QuotationState());

  Future<void> fetchQuotations() async {
    emit(state.copyWith(isLoading: true, errorMessage: null, successMessage: null));

    try {
      final quotations = await _quotationService.fetchAllQuotations();
      emit(state.copyWith(isLoading: false, quotations: quotations));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: "Getting data error!"));
    }
  }
}
