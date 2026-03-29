import 'package:app_twins/services/service.dart';

class ChildrenListPageService {
  ChildrenListPageService({ChildrenApi? childrenApi})
    : _childrenApi = childrenApi ?? ServiceSdk.instance.children;

  final ChildrenApi _childrenApi;

  Future<List<Map<String, dynamic>>> fetchChildren() {
    return _childrenApi.getChildren();
  }
}
