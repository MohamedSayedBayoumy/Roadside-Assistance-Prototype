import 'package:get/get.dart';

class RequestServicesController extends GetxController {
  RxString selectedValue = "".obs;

  List<String> services = [
    'Towing Service',
    'Fuel Delivery',
    'Battery Jump-Start',
    'Tire Change & Inflation',
    'Quick Maintenance',
  ];

  Future<void> selectValue(String value) async {
    selectedValue.value = value;
  }
}
