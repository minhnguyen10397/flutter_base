class TextUtils {
 static bool isEmpty(String? text){
    return text == null || text.trim() == "";
  }

 static bool isNotEmpty(String? text){
    return !isEmpty(text);
  }
}