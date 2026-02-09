import '../core/network/api_client.dart';
import '../models/measurement.dart';

/// Gateway interface for measurement operations
abstract interface class MeasurementsGateway {
  Future<List<Measurement>> getMeasurements(int childId, MeasurementListQuery query);
  Future<LatestMeasurements> getLatestMeasurements(int childId);
  Future<ChartData> getChartData(int childId, ChartDataQuery query);
  Future<Measurement> createMeasurement(int childId, MeasurementCreateRequest request);
  Future<void> deleteMeasurement(int measurementId);
}

/// Implementation of MeasurementsGateway
class MeasurementsGatewayImpl implements MeasurementsGateway {
  MeasurementsGatewayImpl(this._client);

  final ApiClient _client;

  @override
  Future<List<Measurement>> getMeasurements(
    int childId,
    MeasurementListQuery query,
  ) async {
    return _client.get(
      '/api/v1/children/$childId/measurements/list',
      queryParameters: query.toQueryParams(),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => Measurement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<LatestMeasurements> getLatestMeasurements(int childId) async {
    return _client.get(
      '/api/v1/children/$childId/measurements/latest',
      fromJson: (json) =>
          LatestMeasurements.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ChartData> getChartData(int childId, ChartDataQuery query) async {
    return _client.get(
      '/api/v1/children/$childId/measurements/chart',
      queryParameters: query.toQueryParams(),
      fromJson: (json) => ChartData.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Measurement> createMeasurement(
    int childId,
    MeasurementCreateRequest request,
  ) async {
    return _client.post(
      '/api/v1/children/$childId/measurements',
      data: request.toJson(),
      fromJson: (json) => Measurement.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<void> deleteMeasurement(int measurementId) async {
    await _client.delete('/api/v1/measurements/$measurementId');
  }
}
