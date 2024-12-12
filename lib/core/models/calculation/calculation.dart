import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
///
/// Model for running calculations on backend and processing results.
class Calculation {
  final ApiAddress _apiAddress;
  final String _authToken;
  final String _scriptName;
  final Map<String, dynamic> _scriptParams;
  ///
  /// Creates model for running calculations on backend and processing results.
  ///
  /// * [apiAddress] – [ApiAddress] of server that interact with backend script.
  /// * [authToken] – string authentication token for accessing server.
  /// * [scriptName] – name of script to run by server.
  /// * [scriptParams] – additional parameters that will be passed to script.
  const Calculation({
    required ApiAddress apiAddress,
    required String authToken,
    required String scriptName,
    required Map<String, dynamic> scriptParams,
  })  : _apiAddress = apiAddress,
        _authToken = authToken,
        _scriptName = scriptName,
        _scriptParams = scriptParams;
  ///
  /// Starts calculation and returns its result.
  Future<Result<void, Failure<String>>> fetch() {
    final timeout = Duration(
      milliseconds: const Setting('backendResponseTimeout_ms').toInt,
    );
    return ApiRequest(
      authToken: _authToken,
      address: _apiAddress,
      timeout: timeout,
      query: ExecutableQuery(
        script: _scriptName,
        params: _scriptParams,
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
