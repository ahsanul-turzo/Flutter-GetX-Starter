import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;

    // Handle tab navigation
    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Get.toNamed('/example');
        break;
      case 2:
        Get.snackbar('Info', 'Profile page coming soon');
        break;
    }
  }
}
