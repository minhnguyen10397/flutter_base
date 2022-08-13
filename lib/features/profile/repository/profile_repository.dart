import '../../../models/base_model.dart';
import '../../../models/user/user_model.dart';
import '../../../services/api/api_provider.dart';

class ProfileRepository {

  Future<BaseModel<UserModel>> getUserProfile(Map<String, dynamic> param) => ApiProvider.instance.userApi.login(param: param);
}