import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
///
/// Model for running calculations on backend and processing results.
class Calculation {
  final ApiAddress _apiAddress;
  final String _authToken;
  final String _scriptName;
  ///
  /// Creates model for running calculations on backend and processing results.
  ///
  /// - `apiAddress` - [ApiAddress] of server that interact with backend script.
  /// - `authToken` - string authentication token for accessing server.
  /// - `scriptName` - name of script to run by server.
  const Calculation({
    required ApiAddress apiAddress,
    required String authToken,
    required String scriptName,
  })  : _apiAddress = apiAddress,
        _authToken = authToken,
        _scriptName = scriptName;
  ///
  /// Starts calculation and returns its result.
  Future<Result<void, Failure<String>>> fetch() {
    return ApiRequest(
      authToken: _authToken,
      address: _apiAddress,
      timeout: const Duration(seconds: 15),
      query: ExecutableQuery(
        script: _scriptName,
        params: {"message": "start"},
      ),
    )
        .fetch()
        .then<Result<void, Failure<String>>>(
          (result) => switch (result) {
            Ok(value: final reply) => _mapReply(reply),
            Err(:final error) => Err(
                Failure(
                  message: '$error',
                  stackTrace: StackTrace.current,
                ),
              ),
          },
        )
        .onError(
          (error, stackTrace) => Err(Failure(
            message: '$error',
            stackTrace: stackTrace,
          )),
        );
  }
  //
  Result<void, Failure<String>> _mapReply(ApiReply reply) {
    final data = reply.data;
    if (data.isEmpty) {
      return Err(Failure(
        message: const Localized('Unknown error, no response from backend').v,
        stackTrace: StackTrace.current,
      ));
    }
    if (data.any((data) => data['status'] != 'ok')) {
      return Err(Failure(
        message:
            '${const Localized('Backend error').v}, ${reply.data.firstWhere((data) => data['status'] != 'ok')['message']}',
        stackTrace: StackTrace.current,
      ));
    }
    return const Ok(null);
  }
}
