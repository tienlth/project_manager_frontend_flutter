import 'package:get_it/get_it.dart';
import 'package:project_management/network/dio_client.dart';

class QuotationApiService {
  final DioClient _dio = GetIt.instance<DioClient>();

  Future<List<dynamic>> fetchAllQuotations() async {
    final response = await _dio.get('/quotations');
    return response.data;
  }

}
