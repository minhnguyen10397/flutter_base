import '../../base/base_endpoint.dart';
import '../../base/method_request.dart';

abstract class AuthEndpointProtocol {
  EndpointType login(Map<String, dynamic> param);

  EndpointType register(Map<String, dynamic> param);
}

class AuthEndpoint with AuthEndpointProtocol {
  @override
  EndpointType login(Map<String, dynamic> param) {
    final endpoint = EndpointType(
        path: "api/user/login",
        httpMethod: HttpMethod.post,
        parameters: param,
        header: DefaultHeader.instance.addDefaultHeader());
    return endpoint;
  }

  @override
  EndpointType register(Map<String, dynamic> param) {
    final endpoint = EndpointType(
        path: "api/user/signup",
        httpMethod: HttpMethod.post,
        parameters: param,
        header: DefaultHeader.instance.addDefaultHeader());
    return endpoint;
  }
}
