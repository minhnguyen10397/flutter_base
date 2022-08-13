import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import '../local/local_data_helper.dart';

abstract class FileRequestProtocol {
  Future<String?> uploadImage(File file);

  Future<String?> uploadFile(File file);
}

class FileRequest extends FileRequestProtocol {
  FileRequest._();

  static const String tag = 'FileRequest';
  static final FileRequest instance = FileRequest._();

  Dio? dio;

  Dio init() {
    if (dio == null) {
      dio = Dio();
      dio!.options.connectTimeout = 45000;
      dio!.options.receiveTimeout = 45000;
      // dio!.options.baseUrl = ENVConfig.instance.wsBaseUrl;
    }
    return dio!;
  }

  @override
  Future<String?> uploadImage(File file) async {
    final dio = init();
    img.Image? image = img.decodeImage(file.readAsBytesSync());
    if (image == null) {
      return null;
    }
    img.Image smallerImage = img.copyResize(image, width: 512);
    final tempDir = await getTemporaryDirectory();
    final resizeFile = File("${tempDir.path}/${basename(file.path)}")
      ..writeAsBytesSync(img.encodeJpg(smallerImage));


    FormData formData = FormData();
    formData.files.add(MapEntry(
      "upload",
      await MultipartFile.fromFile(
        resizeFile.path,
        contentType: MediaType('image', 'png'),
        filename: "img_${DateTime.now().millisecondsSinceEpoch}.png",
      ),
    ));
    final header = <String, dynamic>{};
    final token = await LocalDataHelper.instance.getToken();
    if (token != null) {
      header["Authorization"] = "Bearer $token";
    }
    Response response = await dio.post("_api/common/upload-s3",
        options: Options(headers: header), data: formData);
    final data = response.data as Map<String, dynamic>;
    if (data.containsKey("data")) {
      final resultData = data["data"] as Map<String, dynamic>;
      return resultData["url"];
    }
    return null;
  }

  @override
  Future<String?> uploadFile(File file) async {
    final dio = init();
    FormData formData = FormData();
    formData.files.add(
      MapEntry(
        "upload",
        await MultipartFile.fromFile(
          file.path,
          filename:
              "file_${DateTime.now().millisecondsSinceEpoch}.${_getFileExtension(file.path)}",
        ),
      ),
    );
    final header = <String, dynamic>{};
    final token = await LocalDataHelper.instance.getToken();
    if (token != null) {
      header["Authorization"] = "Bearer $token";
    }
    Response response = await dio
        .post(
      "_api/common/upload-file-s3",
      options: Options(headers: header),
      data: formData,
    )
        .catchError((e) async {
      // debugPrint(e.toString());
      // String? newToken = await UserUtils.refreshToken();
    });
    final data = response.data as Map<String, dynamic>;
    if (data.containsKey("data")) {
      final resultData = data["data"] as Map<String, dynamic>;
      return resultData["url"];
    }
    return null;
  }

  String _getFileExtension(String fileName) {
    try {
      return "." + fileName.split('.').last;
    } catch (e) {
      return '';
    }
  }
}
