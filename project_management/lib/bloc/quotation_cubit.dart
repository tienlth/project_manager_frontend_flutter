import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/network/services/quotation_api_service.dart';

class QuotationState {
  final List<dynamic> quotations;
  final Map<String, dynamic>? quotationDetail;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  QuotationState({
    this.quotations = const [],
    this.quotationDetail,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  QuotationState copyWith({
    List<dynamic>? quotations,
    Map<String, dynamic>? quotationDetail,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return QuotationState(
      quotations: quotations ?? this.quotations,
      quotationDetail: quotationDetail ?? this.quotationDetail,
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
      emit(state.copyWith(isLoading: false, errorMessage: "Lỗi khi lấy danh sách báo giá!"));
    }
  }

  Future<void> fetchQuotationDetail(String quotationId) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, successMessage: null));

    try {
      final quotationDetail = await _quotationService.fetchQuotationById(quotationId);
      emit(state.copyWith(isLoading: false, quotationDetail: quotationDetail));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: "Lỗi khi lấy chi tiết báo giá!"));
    }
  }
}
