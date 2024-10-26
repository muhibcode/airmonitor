import 'package:get/get.dart';

class HomeController extends GetxController {
  var timeCount = 0.obs;
  // var flaskUrl = ''.obs;

  getUrl() {}
  incTime() {
    timeCount.value = 1;
  }

  decTime() {
    timeCount.value = 0;
  }
}
