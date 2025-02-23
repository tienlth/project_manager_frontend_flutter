import 'package:get_it/get_it.dart';
import 'package:project_management/network/dio_client.dart';

class QuotationApiService {
  final DioClient _dio = GetIt.instance<DioClient>();

  Future<List<dynamic>> fetchAllQuotations() async {
    final response = await _dio.get('/quotations');
    return response.data;
  }

  Future<Map<String, dynamic>> fetchQuotationById(String quotationId) async {
    final response = await _dio.get('/quotations/$quotationId');
    return response.data;
  }

  Future<Map<String, dynamic>> fetchQuotationPreview(String project) async {
    final response = await _dio.get('/quotations/$project/preview');
    return response.data;
  }

}
