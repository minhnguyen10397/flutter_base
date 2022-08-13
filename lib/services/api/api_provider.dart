import 'package:gold/services/api/user/user_api.dart';

class ApiProvider {
  ApiProvider._();

  static final ApiProvider instance = ApiProvider._();

  UserApi get userApi {
    return UserApiImpl();
  }
}
