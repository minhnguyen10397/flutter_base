import 'package:gold/models/user/user_model.dart';

import '../../../models/base_model.dart';
import '../../../models/user/data_register_model.dart';
import '../../../services/api/api_provider.dart';

class AuthenticationRepository {
  Future<BaseModel<UserModel>> login(Map<String, dynamic> param) =>
      ApiProvider.instance.userApi.login(param: param);

  Future<BaseModel<bool>> register(Map<String, dynamic> param) =>
      ApiProvider.instance.userApi.register(param: param);
}
