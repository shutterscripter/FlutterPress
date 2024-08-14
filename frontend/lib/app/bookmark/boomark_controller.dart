import 'package:get/get.dart';
import 'package:hive/hive.dart';

class BookmarkController extends GetxController {
  var isBookmarked = false.obs;
  final box = Hive.box('MyNews');

  void toggleBookmark(String url, Map<String, dynamic> articleData) async {
    if (box.containsKey(url)) {
      await box.delete(url);
      isBookmarked.value = false;
    } else {
      await box.put(url, articleData);
      isBookmarked.value = true;
    }
  }

}
