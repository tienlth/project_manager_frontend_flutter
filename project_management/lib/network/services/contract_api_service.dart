import 'package:get_it/get_it.dart';
import 'package:project_management/network/dio_client.dart';

class ContractApiService {
  final DioClient _dio = GetIt.instance<DioClient>();

  Future<List<dynamic>> fetchAllContracts() async {
    final response = await _dio.get('/contracts');
    return response.data;
  }

}
