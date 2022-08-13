import 'package:gold/models/user/data_register_model.dart';
import 'package:gold/services/api/user/user_endpoint.dart';

import '../../../models/base_model.dart';
import '../../../models/user/user_model.dart';
import '../../base/base_response.dart';
import '../../local/local_data_helper.dart';
import '../api_service.dart';

abstract class UserApi {
  Future<BaseModel<UserModel>> login({required Map<String, dynamic> param});

  Future<BaseModel<bool>> register({required Map<String, dynamic> param});
}

class UserApiImpl extends UserApi {
  @override
  Future<BaseModel<UserModel>> login(
      {required Map<String, dynamic> param}) async {
    BaseResponse apiResponse =
        await APIService.instance.requestData(AuthEndpoint().login(param));
    if (apiResponse.status == 200) {
      String? token = apiResponse.data?['token'];
      if (token != null) {
        await LocalDataHelper.instance.setToken(token);
      }
      String? refreshToken = apiResponse.data?['refreshToken'];
      if (refreshToken != null) {
        await LocalDataHelper.instance.setRefreshToken(refreshToken);
      }
      UserModel user = UserModel.fromJson(apiResponse.data);
      await LocalDataHelper.instance.setUser(user.userId ?? 0);
      return BaseModel<UserModel>(status: true, data: user);
    } else {
      return BaseModel<UserModel>(
        status: false,
        message: apiResponse.message,
        errCode: apiResponse.errCode,
      );
    }
  }

  @override
  Future<BaseModel<bool>> register(
      {required Map<String, dynamic> param}) async {
    BaseResponse apiResponse =
        await APIService.instance.requestData(AuthEndpoint().register(param));
    if (apiResponse.status == 200) {
      return BaseModel<bool>(status: true, data: true);
    } else {
      return BaseModel<bool>(status: false, message: apiResponse.message);
    }
  }
}
