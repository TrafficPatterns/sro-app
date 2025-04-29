import 'package:get/get.dart';
import 'package:sro/pages/account_details/account_details_controller.dart';

class AccountDetailsdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountDetailsController>(() => AccountDetailsController());
  }
}
