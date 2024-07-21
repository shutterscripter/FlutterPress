import 'package:get/get.dart';
import 'package:hive/hive.dart';

class BookmarkController extends GetxController {
  var isBookmarked = false.obs;

  void toggleBookmark(String url, Map<String, dynamic> articleData) async {
    final box = Hive.box('MyNews');
    if (box.containsKey(url)) {
      await box.delete(url);
      isBookmarked.value = false;
    } else {
      await box.put(url, articleData);
      isBookmarked.value = true;
    }
  }
}