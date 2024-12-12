import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/extensions/future_result_extension.dart';
///
/// Model to interact with api server for generating report.
class Report {
  final ApiAddress _apiAddress;
  final String _authToken;
  ///
  /// Creates model to interact with api server for generating report.
  ///
  /// * [apiAddress] – [ApiAddress] of server that interact with backend script.
  /// * [authToken] – string authentication token for accessing server.
  const Report({
    required ApiAddress apiAddress,
    required String authToken,
  })  : _apiAddress = apiAddress,
        _authToken = authToken;
  ///
  /// Generate report with [fileName] at [outputPath].
  ///
  /// Returns [Ok] with path to generated report or [Err] with error message.
  Future<Result<String, Failure<String>>> generate({
    required String fileName,
    required String outputPath,
  }) {
    final timeout = Duration(
      milliseconds: const Setting('backendResponseTimeout_ms').toInt,
    );
    return ApiRequest(
      authToken: _authToken,
      address: _apiAddress,
      timeout: timeout,
      query: ExecutableQuery(
        script: 'generate_report',
        params: {
          'fileName': fileName,
          'outputPath': outputPath,
        },
      ),
    )
        .fetch()
        .then(
          (result) => result.andThen(_mapReply),
        )
        .convertFailure();
  }
  ///
  /// TODO: remove
  /// Generate report with [fileName] at [outputPath]. Fake implementation.
  Future<Result<String, Failure<String>>> generateFake({
    required String fileName,
    required String outputPath,
  }) =>
      Future.delayed(
        const Duration(seconds: 3),
        () => const Ok('/Users/testpath'),
      );
  //
  // TODO: discuss reply data format
  Result<String, Failure<String>> _mapReply(ApiReply reply) {
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
    return const Ok('');
  }
}
