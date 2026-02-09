import '../core/network/api_client.dart';
import '../models/child.dart';

/// Gateway interface for children operations
abstract interface class ChildrenGateway {
  Future<List<ChildListItem>> getChildren();
  Future<Child> getChild(int childId);
  Future<Child> createChild(ChildCreateRequest request);
  Future<Child> updateChild(int childId, ChildUpdateRequest request);
  Future<void> deleteChild(int childId);
  Future<void> selectChild(int childId);
}

/// Implementation of ChildrenGateway
class ChildrenGatewayImpl implements ChildrenGateway {
  ChildrenGatewayImpl(this._client);

  final ApiClient _client;

  @override
  Future<List<ChildListItem>> getChildren() async {
    return _client.get(
      '/api/v1/children',
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChildListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<Child> getChild(int childId) async {
    return _client.get(
      '/api/v1/children/$childId',
      fromJson: (json) => Child.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Child> createChild(ChildCreateRequest request) async {
    return _client.post(
      '/api/v1/children',
      data: request.toJson(),
      fromJson: (json) => Child.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Child> updateChild(int childId, ChildUpdateRequest request) async {
    return _client.patch(
      '/api/v1/children/$childId',
      data: request.toJson(),
      fromJson: (json) => Child.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<void> deleteChild(int childId) async {
    await _client.delete('/api/v1/children/$childId');
  }

  @override
  Future<void> selectChild(int childId) async {
    await _client.post('/api/v1/children/$childId/select');
  }
}
