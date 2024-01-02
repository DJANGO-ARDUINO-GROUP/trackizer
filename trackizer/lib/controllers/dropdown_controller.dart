import 'package:get/get.dart';

class DropdownController extends GetxController {
  Rx<String?> selectedValue = Rx<String?>(null);
  Rx<int?> selectedId = Rx<int?>(null);

  void updateSelectedValue({required String name, required int id}) {
    selectedValue.value = name;
    selectedId.value = id;
  }
}
